// deploy.js is a file for deploying the contract in the production blockchain
// to run this script run the terminal command with specifing the network: npx hardhat run scripts/deploy.js --network rinkeby

const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
  
    console.log('Deploying contracts with account: ', deployer.address);
    console.log('Account balance: ', accountBalance.toString());
  
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
      //  fund the contract with 0.001 ETH
      value: hre.ethers.utils.parseEther('0.001'),
    });

    await waveContract.deployed();

    console.log('WavePortal address: ', waveContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();

  //0x7aF18FF875Db809aF6d17D70718D52bf101d73c7 - WavePortal address