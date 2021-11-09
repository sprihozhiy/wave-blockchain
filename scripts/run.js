const main = async () => {

    const [owner, randomPerson] = await hre.ethers.getSigners();

    // compile our contract and generate the necessary files we need to work with our contract under the artifacts directory
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');

    // Hardhat creates a local Ethereum network
    const waveContract = await waveContractFactory.deploy();

    // Deploying the contract to the local Ethereum network
    await waveContract.deployed();

    console.log("The contract was deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);

    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    
    let waveTxn = await waveContract.wave();
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson).wave();
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();
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