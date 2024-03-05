import { expect } from "chai";
import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers";

import { expandTo18Decimals, expandTo6Decimals } from "./utils/utilities";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { Anryton, Anryton__factory } from "../typechain-types";

describe("Networking", function () {
  let AnrytonToken: Anryton; 
  let owner: SignerWithAddress;
  let signers: SignerWithAddress[];
  let provider: any;
  let zeroAddress = "0x0000000000000000000000000000000000000000";

  beforeEach("Token deployment", async () => {
    signers = await ethers.getSigners();
    owner = signers[0];
    AnrytonToken = await new Anryton__factory(owner).deploy();
    await AnrytonToken
      .connect(owner)
      .initialize("Anryton","ANRYTON",owner);

  })

  it("Mint function should revert ",async()=>{
    // await expect(AnrytonToken.connect(owner).mint()).to.be.revertedWithCustomError(AnrytonToken, "TotalSupplyLimitExceeded")
  })
});