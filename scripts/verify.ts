const Hre = require("hardhat");

async function main() {


    await Hre.run("verify:verify",{
      address: "0x1fb9fC836E2BAa7a6572a8D3bd31EbEFA9143974",
      contract: "contracts/Anryton.sol:Anryton"
    });

    
}
main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});