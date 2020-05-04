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
