const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("NoobNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);

    // mint 1st nft
    let txn = await nftContract.makeNFT();
    await txn.wait();
    console.log("Minted NFT #1");
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        process.exit(1);
    }
};

runMain();