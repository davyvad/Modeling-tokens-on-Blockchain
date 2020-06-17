# Modeling-tokens-on-Blockchain
In this project we are willing to model and implement dynamic inter-tokens dependencies on Ethereum platform. The goal is essentially to implement two types of tokens: asset ownership and asset rental tokens. In this implementation we use ERC20 standard.

Steps for installing the environnement:
1) Download Nodejs (this will install npm too) with the following link https://nodejs.org/en/ and install it. 
   (After installing it you can check the installation version by writing the command "node -v" in the command prompt and "nmp -v")
2) Install the IDE: we choose to work with Visual Studio since it is convenient to developp smart contracts. 
  - You can download and install it from https://code.visualstudio.com/
  - Install Visual Studio extension: go to the extensions section and install these plugins 
      •	Solidity
      •	Material Icon Theme
  - Enable icon theme: select File -> Preferences -> Fill icon theme 
3) Install truffle : npm install -g truffle (in the regular command prompt)
4) Create a new directory for the truffle project:
      mkdir Modeling-tokens-on-Blockchain
      cd Modeling-tokens-on-Blockchain
      truffle init 
5) Install OpenZeppelin: it's a library for writing smart contracts on ethereum
      npm init -y
      npm install -E openzeppelin-solidity
5) Open the directory in Visual Studio with the command
      code .
You can see several directories:
    - contracts : directory to store the smart contracts that are created 
    - migrations : directory for deploying the smart contracts into the blockchain
    - tests : directory for testing the smart contracts 
    
Steps for deploying a new smart contract:
1) Add the code of the smart contract under the directory contracts/ let's say for the simple example MetaCoin.sol (you can find this file in the git repository)
2) Add the test for MetaCoin under the test/ directory.
3) Add a migration file that will deploy the MetaCoin, named 2_deploy_contracts.js and define there the deployment of the MetaCoin(the index is important because it defines in which order the compiler should look at the files) 
4) Run the test with the command "truffle test" (in the command prompt). This command will compile the files and run the tests that are written for the MetaCoin
5) Now we can deploy the smart contracts using ganache. First install ganache with the following command:
    npm install -g ganache-cli
6) Open a truffle console with the command
    truffle develop 
7) For convenience you can open a second tab where you can see the log of the transactions. Run the command 
    truffle develop --log 
8) In the first tab use the command "migrate" to deploy the contracts
9) You can see the transactions cache, the contract address, the account that it came from, the balance of that account...


# Using ganache:
Migrate all the contracts to the ganache network with:
truffle migrate --compile-all --reset --network ganache ('ganahe' is the name of the network in the truffle-config.js)
Lunch a ganache console:
truffle console --network ganache 

## Example how to use the ganache console:
 
1) Instantiate a token OwnershipToken with a balance of 1 to the msgSender (msgSender is what's mentioned in the brackets: from accounts[9]): 
let Instance = await OwnershipToken.new("nam", "sym", {from:accounts[9]})
2) let accounts = await web3.eth.getAccounts()

3) to get balance of a certain account:
 let balance = await Instance.getBalance(accounts[0]) 

let rental = await SmartRentalToken.new("nam", "symb", {from:accounts[5]})
let owner = await SmartOwnershipToken.new("nam", "symb")



let owner = await SmartOwnershipToken.new("nam", "sym", {from:accounts[6]})
let renter = await SmartRentalToken.new("nam", "sym", {from:accounts[6]})
owner.setRenter(renter.address, {from:accounts[6]})

renter.rent_begin(accounts[5], {from:accounts[6]})
renter.balanceOf(accounts[6]) 
renter.balanceOf(accounts[5]) 

renter.rent_end({from:accounts[5]})
renter.balanceOf(accounts[6]) 
 

owner.sell(accounts[4], {from:accounts[6]})
owner.balanceOf(accounts[6]) 
owner.balanceOf(accounts[4]) 


// NEW SIMULATION
// A=6, B=7, C=8, D=9
let accounts = await web3.eth.getAccounts()
let owner = await SmartOwnershipToken.new("nam", "sym", {from:accounts[6]})
let array = [accounts[7], accounts[8]]
owner.startRent(array, 3 {from:accounts[6]})
let rentA = await owner.getRentalToken()
let rent = await SmartRentalToken.at(rentA)
//should fail:awa
rent.transfer(accounts[9], 1, {from:accounts[6]}) 
//should succeed:
rent.transfer(accounts[7], 1, {from:accounts[6]}) 
//should fail before the time is over
rent.transfer(accounts[6], 1, {from:accounts[6]}) 
//should fail:
rent.transfer(accounts[9], 1, {from:accounts[7]}) 
//should succeed within the right time
rent.transfer(accounts[8], 1, {from:accounts[7]}) 
//should fail because asset is in rent
owner.transfer(accounts[9], 1, {from:accounts[6]})
//wait the right time
rent.remainingTime()
//should fail
rent.transfer(accounts[7], 1, {from:accounts[8]})
//should succeed
rent.transfer(accounts[6], 1, {from:accounts[6]})
owner.transfer(accounts[9], 1, {from:accounts[6]})
owner.balanceOf(accounts[9]) 

//DYNAMIC LINKING EXTENSION:
let owner = await SmartOwnershipToken.new("nam", "symb")
let ext = await OwnershipExtension.new()
let methodSignature = ""
let preCond = true
let extensionSignature = "setVal()"
let val = await owner.getVal.call()
val.valueOf()
let _parameters = 0
ext.addExtension(methodSignature, preCond, extensionSignature, _parameters) 
let extensionName = "FirstExtension"
owner.addExtension(extensionName, ext.address)
let result = await owner.check_preconditions()

owner.addExtension("function endRentFromOwner()", ext.address)
owner.invokeExtension("function endRentFromOwner()", 0, 2, 2)
let res = await owner.invokeExtension(ext.address)

let a = await DynamicOwnership.new("MyCar", "Car")
let b = await Extension.new()
a.addExtension("Extension", b.address)
let params = await web3.eth.abi.encodeParameters(['address[]', 'uint'], [accounts, '3'])
a.invokeExtension("Extension", "startRent", params)
rentA = await a.getMapElement("Extension_renterToken") //JUSQUE LA CA MARCHE => on a un code dune adresse jai pas reussi a decoder ca
addrRentA = await web3.eth.abi.decodeParameters(rentA, ['address'])
rent = await DynamicRental.at(rentA)
let s = a.getMapElement("msgssender")

//Transfer fonctionne :
a.transfer(accounts[3],1)
a.balanceOf(accounts[3]) //works fine!

//CONVENTION: a variable a of an Extension named B in the mapping extensionsData is stored under the string "B_a"


use of string utils from:
https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol

To encode from console : 
Single param : 
    web3.eth.abi.encodeParameter('address[]', accounts)
Multiple params: 
    web3.eth.abi.encodeParameters(['address[]', 'uint'], [accounts, '3'])
