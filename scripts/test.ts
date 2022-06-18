import { ethers } from "hardhat";

async function main() {

  // We get the contract to deploy
  const Credit = await ethers.getContractFactory("CreditTracker");
  const credit = await Credit.deploy("You've deployed it successfully!!!");

  await credit.deployed();

  console.log("Collateral deployed to:", credit.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});