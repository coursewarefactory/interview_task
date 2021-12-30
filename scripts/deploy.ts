import { ethers } from "hardhat";

async function main() {
  const Terrain = await ethers.getContractFactory("Terrain");
  await terrain.deployed();
  console.log("Terrain address:", terrain.address); // eslint-disable-line no-console
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error); // eslint-disable-line no-console
    process.exit(1);
  });
