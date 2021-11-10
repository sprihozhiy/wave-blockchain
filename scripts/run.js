// run.js is a file for testing the contract in the local blockchain
// to run this script run the terminal command: npx hardhat run scripts/run.js

const main = async () => {
    // compile our contract and generate the necessary files we need to work with our contract under the artifacts directory
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    // Hardhat creates a local Ethereum network
    const waveContract = await waveContractFactory.deploy({
        // FUND THE CONTRACT WITH 0.1 ETH DURING THE DEPLOY
        value: hre.ethers.utils.parseEther('0.1'),
    });
    // Deploying the contract to the Ethereum network
    await waveContract.deployed();
    console.log("The contract was deployed to:", waveContract.address);


    // Get Contract balance
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
      );
      console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    // Get total number of waves
    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    
    // Get all waves
    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
    
    // Get contract balance to see what happened
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    // Send one Wave
    let waveTxn = await waveContract.wave('A message!');
    await waveTxn.wait(); // Wait for the transaction to be mined
    
    // Generate random message senders for several waves
    /* const [_, randomPerson] = await hre.ethers.getSigners();
    *  waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
    *  await waveTxn.wait(); // Wait for the transaction to be mined
    */
    
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();