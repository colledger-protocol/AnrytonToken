import { ethers } from 'ethers';

const SIGNING_DOMAIN_NAME = "Rapi";
const SIGNING_DOMAIN_VERSION = "1";


class orderhash {
  public contract: any;
  public signer: any;
  public _domain: any;

  constructor(data: any) {
    const { _contract, _signer } = data;
    this.contract = _contract;
    this.signer = _signer;
  }


  async createVoucher(token: any, user: any, amount: any, adminId: any, 
    withdrawalId: any) {
    const Voucher = {token, user, amount, adminId, withdrawalId};
const domain = await this._signingDomain();
    const types = {
      withdrawalApproved: [
        { name: "token", type: "address" },
        { name: "user", type: "address" },
        { name: "amount", type: "uint256" },
        { name: "adminId", type: "string" },
        { name: "withdrawalId", type: "string" }
      ],
    };


    

    const signature = await this.signer._signTypedData(domain, types, Voucher);
    
    return {
      ...Voucher,
      signature,
    };
  }


  
  async _signingDomain() {
    if (this._domain != null) {
      return this._domain;
    }
    const chainId = 31337;
    this._domain = {
      name: SIGNING_DOMAIN_NAME,
      version: SIGNING_DOMAIN_VERSION,
      verifyingContract: this.contract.address,
      chainId,
    };
    return this._domain;
  }

}


//async function  main() {

//    const voucher = await createVoucher(
//       5, // specify the name of the parameter
//       50,
//       "uri",
//       "0x17F6AD8Ef982297579C203069C1DbfFE4348c372",
//    ) ;
//       // the address is the address which receives the NFT
//    console.log(
//      `[${voucher.tokenID}, ${voucher.price}, "${voucher.uri}", "${voucher.buyer}", "${voucher.signature}"]`
//    );
//  }

//}



export default orderhash;





