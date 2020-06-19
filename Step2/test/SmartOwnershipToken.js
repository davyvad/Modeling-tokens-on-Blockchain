const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");
const SmartRentalToken = artifacts.require("SmartRentalToken");

const truffleAssert = require('truffle-assertions');


contract('SmartOwnershipToken', (accounts) => {
  it('Demo for SmartOwnershipContract', async () => {
    console.log("1.Run/setup the test environment");

    // 2.Mint the Asset OWNERSHIP token to A
    console.log("2.Mint the Asset OWNERSHIP token to A");
    const owner = await SmartOwnershipToken.new("Naomie's car", "Car", {from:accounts[6]});
    var balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 3.Mint the rental token to A such that the rental token can be moved between B and C within 3 min after creation
    console.log("3.Mint the rental token to A such that the rental token can be moved between B and C within 3 min after creation");
    const array = [accounts[7], accounts[8]];
    owner.startRent(array, 3, {from:accounts[6]});
    balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 4.Attempt of A to transfer the rental token to D, which should fail
    console.log("4.Attempt of A to transfer the rental token to D, which should fail");
    const rentA = await owner.getRentalToken();
    const rent = await SmartRentalToken.at(rentA);
    //should fail:
    await truffleAssert.reverts(rent.transfer(accounts[9], 1, {from:accounts[6]}), "Recipient not allowed in rent");
    var balanceAr = await rent.balanceOf.call(accounts[6]);
    var balanceDr = await rent.balanceOf.call(accounts[9]);
    console.log("Balance of Rental token accounts[6]=", balanceAr.toNumber());
    console.log("Balance of Rental token accounts[9]=", balanceDr.toNumber());
    assert.equal(balanceAr.valueOf(), 1, "balance of account 6 should be 1");
    assert.equal(balanceDr.valueOf(), 0, "balance of account 6 should be 1");


    // 5.Transfer of rental token from A to B
    console.log("5.Transfer of rental token from A to B");
    //should succeed:
    rent.transfer(accounts[7], 1, {from:accounts[6]}) ;
    var balanceBr = await rent.balanceOf.call(accounts[7]);
    balanceAr = await rent.balanceOf.call(accounts[6]);
    console.log("Balance of Rental token accounts[6]=", balanceAr.toNumber());
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    assert.equal(balanceAr.valueOf(), 0, "balance of account 6 should be 1");
    assert.equal(balanceBr.valueOf(), 1, "balance of account 6 should be 1");

    // 6.Attempt of A to transfer the rental token to himself (A), before the end of 3 min interval, which should fail.
    console.log("6.Attempt of A to transfer the rental token to himself (A), before the end of 3 min interval, which should fail.");
    await truffleAssert.reverts(rent.transfer(accounts[6], 1, {from:accounts[6]}), "Not allowed to make tranfer");
    balanceBr = await rent.balanceOf.call(accounts[7]);
    balanceAr = await rent.balanceOf.call(accounts[6]);
    console.log("Balance of Rental token accounts[6]=", balanceAr.toNumber());
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    assert.equal(balanceAr.valueOf(), 0, "balance of account 6 should be 0");
    assert.equal(balanceBr.valueOf(), 1, "balance of account 7 should be 1");

    // 7.Attempt of B to transfer the rental token to D, which should fail.
    console.log("7.Attempt of B to transfer the rental token to D, which should fail.");
    await truffleAssert.reverts(rent.transfer(accounts[9], 1, {from:accounts[7]}) , "Recipient not allowed in rent");
    balanceBr = await rent.balanceOf.call(accounts[7]);
    balanceDr = await rent.balanceOf.call(accounts[9]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    console.log("Balance of Rental token accounts[9]=", balanceDr.toNumber());
    assert.equal(balanceBr.valueOf(), 1, "balance of account 7 should be 1");
    assert.equal(balanceDr.valueOf(), 0, "balance of account 9 should be 0");

    // 8.Transfer the rental token from B to C (within 3 min time interval)
    console.log("8.Transfer the rental token from B to C (within 3 min time interval)");
    rent.transfer(accounts[8], 1, {from:accounts[7]}) ;
    balanceBr = await rent.balanceOf.call(accounts[7]);
    var balanceCr = await rent.balanceOf.call(accounts[8]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    console.log("Balance of Rental token accounts[8]=", balanceCr.toNumber());
    assert.equal(balanceBr.valueOf(), 0, "balance of account 7 should be 0");
    assert.equal(balanceCr.valueOf(), 1, "balance of account 8 should be 1");

    // 9.Attempt of A to transfer the OWNERSHIP token to D, which should fail.
    console.log("9.Attempt of A to transfer the OWNERSHIP token to D, which should fail.");
    await truffleAssert.reverts(owner.transfer(accounts[9], 1, {from:accounts[6]}) , "the item is on rent");
    balanceA = await owner.balanceOf.call(accounts[6]);
    var balanceD = await owner.balanceOf.call(accounts[9]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    console.log("Balance of Owner token accounts[9]=", balanceD.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");
    assert.equal(balanceD.valueOf(), 0, "balance of account 9 should be 0");

    //wait the right time
    var d = Date.now();
    var d2 = null;
    do{ d2 = Date.now();
      //console.log("de");
    }
    while( d2-d < (3 * 60 * 1000));

    // 10.Attempt of C to transfer the rental token to B, which should fail after 3 min interval
    console.log("10.Attempt of C to transfer the rental token to B, which should fail after 3 min interval");
    await truffleAssert.reverts(rent.transfer(accounts[7], 1, {from:accounts[8]}) , "Rent is out of date");
    balanceBr = await rent.balanceOf.call(accounts[7]);
    balanceCr = await rent.balanceOf.call(accounts[8]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    console.log("Balance of Rental token accounts[8]=", balanceCr.toNumber());
    assert.equal(balanceBr.valueOf(), 0, "balance of account 6 should be 1");
    assert.equal(balanceCr.valueOf(), 1, "balance of account 9 should be 0");

    // 11.Transfer of rental token to A by A from C, after 3 min interval
    console.log("11.Transfer of rental token to A by A from C, after 3 min interval");
    rent.transfer(accounts[6], 1, {from:accounts[6]});
    balanceAr = await rent.balanceOf.call(accounts[6]);
    balanceCr = await rent.balanceOf.call(accounts[8]);
    console.log("Balance of Rental token accounts[6]=", balanceAr.toNumber());
    console.log("Balance of Rental token accounts[8]=", balanceCr.toNumber());
    assert.equal(balanceAr.valueOf(), 1, "balance of account 6 should be 1");
    assert.equal(balanceCr.valueOf(), 0, "balance of account 8 should be 0");

    // 12.Transfer of the OWNERSHIP token from A to D that automatically burns the rental token.
    console.log("12.Transfer of the OWNERSHIP token from A to D that automatically burns the rental token.");
    owner.transfer(accounts[9], 1, {from:accounts[6]}); 
    balanceA = await owner.balanceOf.call(accounts[6]);
    balanceD = await owner.balanceOf.call(accounts[9]);
    console.log("Balance of Rental token accounts[6]=", balanceA.toNumber());
    console.log("Balance of Rental token accounts[9]=", balanceD.toNumber());
    assert.equal(balanceA.valueOf(), 0, "balance of account 6 should be 0");
    assert.equal(balanceD.valueOf(), 1, "balance of account 9 should be 1");    
  });
});
