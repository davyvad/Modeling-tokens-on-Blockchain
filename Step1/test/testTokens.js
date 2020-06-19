const OwnershipToken = artifacts.require("OwnershipToken");
const RentalToken = artifacts.require("RentalToken");

const truffleAssert = require('truffle-assertions');


contract('OwnershipToken', (accounts) => {
  it('Demo for OwnershipContract', async () => {
    console.log("1.Run/setup the test environment: A is accounts[6], B is accounts[7] and so on...");

    // 2.Mint the Asset OWNERSHIP token to A
    console.log("2.Mint the Asset OWNERSHIP token to A");
    const owner = await OwnershipToken.new("A's car", "Car", {from:accounts[6]});
    var balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 3.Transfer the ownership from A to B calling from C
    console.log("3.Transfer the ownership from A to B calling from C - should fail");
    await truffleAssert.reverts(owner.transfer(accounts[7], 1, {from:accounts[8]}), "No permission to make transfer");
    balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 4. Transfer the ownership from A to B calling from A
    console.log("4.Transfer the ownership from A to B calling from A - should succeed");
    owner.transfer(accounts[7], 1, {from:accounts[6]});
    balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    var balanceB = await owner.balanceOf.call(accounts[7]);
    console.log("Balance of Owner token B: accounts[7]=", balanceB.toNumber());
    assert.equal(balanceA.valueOf(), 0, "balance of account 6 should be 0");
    assert.equal(balanceB.valueOf(), 1, "balance of account 7 should be 1");
  });

  it('Demo for RentalContract', async () => {
    console.log("1.Run/setup the test environment");

    // 2.Mint the Asset RENTAL token to A
    console.log("2.Mint the Asset RENTAL token to A");
    const array = [accounts[7], accounts[8]]; //B,C
    const rent = await RentalToken.new("A's car", "Car", array, 3,  {from:accounts[6]});
    var balanceA = await rent.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 3.Transfer the rent from A to D - should fail
    console.log("3.Transfer the ownership from A to D - should fail since D is not in the list");
    await truffleAssert.reverts(rent.transfer(accounts[9], 1, {from:accounts[6]}), "Can't transfer the rent to this recipient");
    balanceA = await rent.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 4.Transfer the rent from A to B
    console.log("4.Transfer the rent from A to B");
    rent.transfer(accounts[7], 1, {from:accounts[6]});
    balanceA = await rent.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token A: accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 0, "balance of account 6 should be 0");
    var balanceB = await rent.balanceOf.call(accounts[7]);
    console.log("Balance of Owner token A: accounts[7]=", balanceA.toNumber());
    assert.equal(balanceB.valueOf(), 1, "balance of account 7 should be 1");

    //wait the right time
    var d = Date.now();
    var d2 = null;
    do{ d2 = Date.now();
      //console.log("de");
    }
    while( d2-d < (3 * 60 * 1000));

    // 5.Attempt of B to transfer the rental token to A, which should fail after 3 min interval
    console.log("5.Attempt of B to transfer the rental token to A, which should fail after 3 min interval");
    await truffleAssert.reverts(rent.transfer(accounts[6], 1, {from:accounts[7]}) , "Rent is out of date");
    balanceA = await rent.balanceOf.call(accounts[6]);
    balanceB = await rent.balanceOf.call(accounts[7]);
    console.log("Balance of Rental token accounts[6]=", balanceA.toNumber());
    console.log("Balance of Rental token accounts[7]=", balanceB.toNumber());
    assert.equal(balanceA.valueOf(), 0, "balance of account 6 should be 0");
    assert.equal(balanceB.valueOf(), 1, "balance of account 7 should be 1");
  
  }); 
});
