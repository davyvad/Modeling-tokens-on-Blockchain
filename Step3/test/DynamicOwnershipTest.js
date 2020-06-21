const DynamicOwnership = artifacts.require("DynamicOwnership");
const DynamicRental = artifacts.require("DynamicRental");
const Extension = artifacts.require("Extension");

const truffleAssert = require('truffle-assertions');


contract('DynamicOwnership', (accounts) => {
  it('Demo for DynamicOwnership', async () => {
    console.log("1.Run/setup the test environment");

    // 2.Mint the Asset OWNERSHIP token to A
    console.log("2.Mint the Asset OWNERSHIP token to A");
    const owner = await DynamicOwnership.new("My car", "Car", {from:accounts[6]});
    var balanceA = await owner.balanceOf.call(accounts[6]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");

    // 3.Create an extension for rental token
    console.log("3.Create an extension for rental token");
    const extension = await Extension.new();

    // 4.Add the extension to the created token
    console.log("4.Add the extension to the created ");
    owner.addExtension("Extension", extension.address, {from:accounts[6]});

    // 5.Invoke the new functions startRent with the group of renters [B,C] for 1 minutes
    console.log("5.Invoke the new functions startRent with the group of renters [B,C] for 1 minutes");
    let params = await web3.eth.abi.encodeParameters(['address[]', 'uint'], [accounts.slice(7,8), '1']);
    owner.invokeExtension("Extension", "startRent", params,{from:accounts[6]});

    // 6.Attempt for Ownership transfer from A to D should fails before the expiration time
    console.log("6.Ownership transfer should fails before the expiration time");
    truffleAssert.fails(owner.transfer(accounts[9], 1, {from:accounts[6]}), truffleAssert.ErrorType.INVALID_OPCODE);
    console.log("6.Ownership transfer should fails before the expiration time");

    balanceA = await owner.balanceOf(accounts[6]);// .call(accounts[6]);
    var balanceD = await owner.balanceOf.call(accounts[9]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    console.log("Balance of Owner token accounts[9]=", balanceD.toNumber());
    assert.equal(balanceA.valueOf(), 1, "balance of account 6 should be 1");
    assert.equal(balanceD.valueOf(), 0, "balance of account 9 should be 0");

    // 7.Access the DynamicRental token
    console.log("7.Access the DynamicRental token");
    var rentA = await owner.getMapElement("Extension_renterToken") ;
    var addrRentA = await web3.eth.abi.decodeParameters(['address'], rentA);
    addrRentA = addrRentA['0'];
    const renterToken = await DynamicRental.at(addrRentA);
    var balanceAr = await renterToken.balanceOf(accounts[6]); //should be one
    console.log("Balance of Rental token accounts[6]=", balanceAr.toNumber());
    assert.equal(balanceAr.valueOf(), 1, "balance of account 6 should be 1");

    // 8.Transfer the rent to a valid renter
    console.log("8.Transfer the rent to a valid renter");
    renterToken.transfer(accounts[7], 1, {from:accounts[6]});
    var balanceBr = await renterToken.balanceOf(accounts[7]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    assert.equal(balanceBr.valueOf(), 1, "balance of account 7 should be 1");

    // 9.Tranfer the rent to an invalid renter, should fail
    console.log("9.Tranfer the rent to an invalid renter, should fail");
    truffleAssert.reverts(renterToken.transfer(accounts[9], 1, {from:accounts[7]}) , "Rent is still valid but recipient isn't valid");
    var balanceBr = await renterToken.balanceOf(accounts[7]);
    var balanceDr = await renterToken.balanceOf(accounts[9]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    console.log("Balance of Rental token accounts[9]=", balanceDr.toNumber());
    assert.equal(balanceBr.valueOf(), 1, "balance of account 7 should be 1");
    assert.equal(balanceDr.valueOf(), 0, "balance of account 9 should be 0");

    // 10.Transfer rent to valid renter by the owner A to C, fails
    console.log("10.Transfer rent to valid renter by the owner, fails");
    truffleAssert.reverts(renterToken.transfer(accounts[8], 1, {from:accounts[6]}) , "Rent is still valid, only mainRenter can transfer");
    balanceBr = await renterToken.balanceOf(accounts[7]);
    var balanceCr = await renterToken.balanceOf(accounts[8]);
    console.log("Balance of Rental token accounts[7]=", balanceBr.toNumber());
    console.log("Balance of Rental token accounts[8]=", balanceCr.toNumber());
    assert.equal(balanceBr.valueOf(), 1, "balance of account 7 should be 1");
    assert.equal(balanceCr.valueOf(), 0, "balance of account 8 should be 0");

    // 11.Waiting 3 minutes and then attempt a transfer of the rent, fails
    console.log("11.Waiting 2 minutes and then attempt a transfer of the rent, fails");
    var d = Date.now();
    var d2 = null;
    do{ d2 = Date.now();
      //console.log("de");
    }
    while( d2-d < (2 * 60 * 1000));

    truffleAssert.reverts(renterToken.transfer(accounts[8], 1, {from:accounts[7]}), "Rent isn't valid, you can only transfer it to owner");
    balanceCr = await renterToken.balanceOf(accounts[8]);
    console.log("Balance of Rental token accounts[8]=", balanceCr.toNumber());
    assert.equal(balanceCr.valueOf(), 0, "balance of account 8 should be 0");

    // 12.Ownership can be transfered and invoke some extenstions again
    console.log("12.Ownership can be transfered and invoke some extenstions again");
    owner.transfer(accounts[9], 1, {from:accounts[6]});
    var balanceA = await owner.balanceOf.call(accounts[6]);
    var balanceD = await owner.balanceOf.call(accounts[9]);
    console.log("Balance of Owner token accounts[6]=", balanceA.toNumber());
    console.log("Balance of Owner token accounts[9]=", balanceD.toNumber());
    assert.equal(balanceA.valueOf(), 0, "balance of account 6 should be 0");
    assert.equal(balanceD.valueOf(), 1, "balance of account 9 should be 1");

    // 13.Remove extension
    console.log("13.Remove extension");
    owner.removeExtension("Extension");
    truffleAssert.reverts(owner.invokeExtension("Extension", "startRent", params), "InvokeExtension didn't suceed");
    console.log("Invokation of the extension failed as expected");
    
    
    });
});
