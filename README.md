# Modeling-tokens-on-Blockchain
In this project we are willing to model and implement dynamic inter-tokens dependencies on Ethereum platform. The goal is essentially to implement two types of tokens: asset ownership and asset rental tokens. In this implementation we use ERC20 standard.
The project is divided in three essentials steps. In the first step, we focus on a stand-alone implementation of the ownership asset and rental asset. The tokens are independant, and cannot have any influence one on the other. Then, in the second step the implementation handles static inter-token dependency, the tokens are dependant one of the other, and there are rules applying to the interactions between the tokens. Finally, the third step is an implementation of dynamic inter-token dependency. In this part you can choose to add an extension to the DynamicOwnership token, to add conditions on the different actions that are made on the token or to add new options on handling the token. These extension can be add at running time, and you won't need to recompile the DynamicOwnership in order to add an extension.

Throughout  this project we use ERC20 standards for all the implemented tokens.

This repository contains for each step a folder that contains all the code of the part according to the description below (see explanation below in "Steps to run each part of the project"), a summary booklet of the project describing more in depth each part of the project and his implementation, the different presentations made along the project and the file truffle-config.js needed in order to use the environment as define below.

# Steps for installing the environment
1) Download Nodejs (this will install npm too) with the following link https://nodejs.org/en/ and install it. 
(After installing it you can check the installation version by writing the command "node -v" in the command prompt and "nmp -v")
2) Install the IDE: we choose to work with Visual Studio since it is convenient to developp smart contracts. 
  - You can download and install it from https://code.visualstudio.com/
  - Install Visual Studio extension: go to the extensions section and install these plugins 
      - Solidity
      - Material Icon Theme
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

////////////////////////////////////////////////////////////////////////////////////
// Dynamic DEMO
////////////////////////////////////////////////////////////////////////////////////
1) Initialize contracts
let a = await DynamicOwnership.new("MyCar", "Car")
let b = await Extension.new()
2) Dynamcally add the extension:
a.addExtension("Extension", b.address)
3) Select a group of renters by accounts and number of minutes:
let params = await web3.eth.abi.encodeParameters(['address[]', 'uint'], [accounts.slice(1,4), '1'])
4) Invoke the new functions startRent with params:
a.invokeExtension("Extension", "startRent", params)
5) Ownership tranfer should fails before the expiration time:
a.transfer(accounts[9], 1) // should fail

6) Get the DynamicRental token:
6.1) Get the stored bytecode data of the rentalToken:
rentA = await a.getMapElement("Extension_renterToken") 
6.2) Decode rentalToken address (If there are more than one params:)
let addrRentA = await web3.eth.abi.decodeParameters(['address'], rentA)
addrRentA = addrRentA['0']
 (If there's only one param, can use this:)
addrRentA = await web3.eth.abi.decodeParameter('address', rentA)
6.3) Convert address to DynamicRental:
let renterToken = await DynamicRental.at(addrRentA)

renterToken.balanceOf(accounts[0]) //should be one
7) Transfer rent to valid renter:
renterToken.transfer(accounts[3], 1)
renterToken.balanceOf(accounts[3]) //should be 1
8) Transfer rent to invalid renter
renterToken.transfer(accounts[6], 1, {from:accounts[3]}) //should fail
9) Transfer rent to valid renter by the owner: Fails
renterToken.transfer(accounts[2], 1) //should fail

/////////////////////////////////////////////////////////
After the expiration time:
10) renterToken cannot be transfered:
renterToken.transfer(accounts[2], 1, {from:accounts[3]}) // should fail
11) Ownership can be transfered and invoke some extenstions again:
a.transfer(accounts[9], 1) //should succeed


///////////////////////////////////////////////////
DRAFT
///////////////////////////////////////////////////
a.transferFrom(accounts[0], accounts[1], 1)

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


    
4) Install ganache, an application that is used in order to test the different contracts implemented along the project. Ganache gives us the ability to fire up a personal Ethereum blockchain that is used to run tests. You can download it with the following link: https://www.trufflesuite.com/ganache

# Steps to run each part of the project
-	Create a new directory => mkdir step1
-	In this directory run the following commands (in the command prompt):
   -	truffle init
   -	npm init -y
   -	npm  install -E openzeppelin-solidity
   -	npm install truffle-assertions
   -	npm install -g ganache-cli
-	Now the current directory has several folders: contracts, migrations, test and node_modules:
    - contracts: directory to store the smart contracts that are created 
    - migrations: directory for deploying the smart contracts into the blockchain
    - tests: directory for testing the smart contracts
    - node_modules: directory that contains the library that we need (erc20…)
-	Add in each directory the files that you can find under the same directory in the Step1 folder
-	Change the content of the file truffle-config.js with the one on the git repository (this file must be located in the directory step1)
-	In order to open visual studio, in the directory step1, run the following command: code . 
-	In order to run the test of the contracts run in the terminal the following command: truffle test --network ganache
(important: we run the test using the ganache network since we are using the accounts provided by ganache in the test. So it is important before running the test that you open ganache application an start a new Ethereum workspace)
-	If you wish to test the contracts on you own you can:
    -	First migrate the contracts with the command: truffle migrate --compile-all –reset
    -	Then open truffle console with the command: truffle console --network ganache
