import { ethers } from "hardhat";
const {upgrades} = require("hardhat");

import {Anryton} from "../typechain-types";


const name = "Anryton";
const symbol = "Anryton";
const owner = "0x92420683A4620302a9801bCA1D6adbE62633d0b9";

async function main() {
  const token = await ethers.getContractFactory("Anryton");
  const stake = await ethers.getContractFactory("Stake");
  console.log("Deploying Anryton...");

  const tokenP = await upgrades.deployProxy(token,[name,symbol,owner],{kind: 'uups'});
  // const tokenP2 = await upgrades.upgradeProxy("0x6b765BdA813C3299034AE6DD4186c20196252A4B",token)
  console.log("tst");
  const Token = await tokenP.getAddress();
  console.log(
    "Token deployed to - ", Token); 

  //   console.log("Deploying Staking...");
  
  // const StakeP = await upgrades.deployProxy(stake,[Token,owner],{kind: 'uups'});
  // const Stake = await StakeP.getAddress();
  // console.log("tst2");
  // console.log(
  //   "Stake deployed to - ", Stake); 


  //   const MyContract = await ethers.getContractFactory('MyContract');
  // const ERC1967Proxy = await ethers.getContractFactory('ERC1967Proxy');

  // const impl = await token.deploy();
  // await impl.waitForDeployment();
  // const proxy = await ERC1967Proxy.deploy(
  //   await impl.getAddress(),
  //   token.interface.encodeFunctionData('initialize', ['Add your initializer arguments here']),
  // );
  // await proxy.waitForDeployment();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
