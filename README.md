# Modeling-tokens-on-Blockchain
In this project we are willing to model and implement dynamic inter-tokens dependencies on Ethereum platform. The goal is essentially to implement two types of tokens: asset ownership and asset rental tokens. In this implementation we use ERC20 standard.
The project is divided in three essentials steps. In the first step, we focus on a stand-alone implementation of the ownership asset and rental asset. The tokens are independant, and cannot have any influence one on the other. Then, in the second step the implementation handles static inter-token dependency, the tokens are dependant one of the other, and there are rules applying to the interactions between the tokens. Finally, the third step is an implementation of dynamic inter-token dependency. In this part you can choose to add an extension to the DynamicOwnership token, to add conditions on the different actions that are made on the token or to add new options on handling the token. These extension can be add at running time, and you won't need to recompile the DynamicOwnership in order to add an extension.

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
