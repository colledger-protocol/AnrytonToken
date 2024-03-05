// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./AnrytonStorage.sol";


contract Anryton is UUPSUpgradeable,ERC20Upgradeable, ERC20BurnableUpgradeable, OwnableUpgradeable, AnrytonStorage  {
    
    struct MintingSale {
        string name;
        uint160 supply;
        address walletAddress;
    }

    mapping(uint => MintingSale) public mintedSale;


    /** track wallet and supply assigned to a particular supply */
    mapping(string => address) private assignedWalletToSale;
    mapping(string => mapping(address => uint256)) private mintedWalletSupply;

    event MintedWalletSuupply(
        string indexed sale,
        uint256 indexed supply,
        address indexed walletAddress
    );

    /**
     * @dev Error indicating that the given amount is zero
     */
    error inputValueZero();
    error TotalSupplyLimitExceeded();

    function initialize(
        string memory _tokenName,
        string memory _tokenSymbol,
        address _owner
    ) external initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        _latestSale = "FRIEND_FAMILY"; 
        mintingCounter = 0;
        __ERC20_init(_tokenName, _tokenSymbol);
        __ERC20Burnable_init();
        _setCommissions();
    }

    function _setCommissions() private {
        _calcSaleSupply(1, "FRIEND_FAMILY", 0x2a92A54A5204Da4455A8cD887a49d523C1737785, 12000000 ether);
        _calcSaleSupply(2, "PRIVATE_SALE", 0xF4FEf7df94C5e631b8469Beeb0B4cbdf895CC824, 24000000 ether);
        _calcSaleSupply(3, "PUBLIC_SALE", 0xD2996de8f493abfe6f14eae27b8f09011db3F283, 24000000 ether);
        _calcSaleSupply(4, "TEAM", 0xC68a6d443db6d2bC420ec6ce1e0Ae4Dd35Eb7aC2, 40000000 ether);
        _calcSaleSupply(5, "RESERVES", 0x7f2157899f58Fa02b21AE97B76f2Aa0870335f85, 100000000 ether);
        _calcSaleSupply(
            6,
            "STORAGE_MINTING_ALLOCATION",
            0xc84fE635e5A448629999A88EF9E11C26570407cb,
            40000000 ether
        );
        _calcSaleSupply(7, "GRANTS_REWARD", 0xBd11b5bF4c53860868B427f765cf243e50030C6c, 80000000 ether);
        _calcSaleSupply(8, "MARKETTING", 0xA01375AC8762cdb4f097124737953b19C11Db9AC, 40000000 ether);
        _calcSaleSupply(9, "ADVISORS", 0x14D48401AaC168c39f7Ea9f3b8B9AB9Cb5293E2A, 12000000 ether);
        _calcSaleSupply(
            10,
            "LIQUIDITY_EXCHANGE_LISTING",
            0xe58E376C32e09397DE7ce57D62950fb79980403f,
            20000000 ether
        );
        _calcSaleSupply(11, "STAKING", 0xDeC28386F7cCa76701d39e9f1b1E682433423A8d, 8000000 ether);

        /** mint once every partician is done
         * First sale will be get minted "FRIEND_FAMILY"
         */
        mint();
    }

    /***
     * @function _calcSaleSupply
     * @dev defining sales in a contract
     */
    function _calcSaleSupply(
        uint8 serial,
        string memory _name,
        address _walletAddress,
        uint160 _supply
    ) private {
        mintedSale[serial].name = _name;
        mintedSale[serial].supply = _supply;
        mintedSale[serial].walletAddress = _walletAddress;
    }

    /***
     * @function mintTokens
     * @dev mint token on a owner address
     * @notice onlyOwner can access this function
     */
    function mint() public onlyOwner {
        uint8 saleCount = ++mintingCounter;
        MintingSale storage mintingSale = mintedSale[saleCount];
        /** Validate amount and address should be greater than zero */
        if (mintingSale.supply == 0) {
            revert inputValueZero();
        }

        if (
            totalSupply() == MAX_TOTAL_SUPPLY ||
            totalSupply() + mintingSale.supply > MAX_TOTAL_SUPPLY
        ) {
            revert TotalSupplyLimitExceeded();
        }
        /** Mint and set default sale supply */
        _mint(mintingSale.walletAddress, mintingSale.supply);
        _setSaleSupplyWallet(
            mintingSale.name,
            mintingSale.walletAddress,
            mintingSale.supply
        );
    }

    /***
     * @function _defaultSupplyWallet
     * @dev persist user address attaches with sale name
     */
    function _setSaleSupplyWallet(
        string memory _saleName,
        address _walletAddress,
        uint256 _supply
    ) private {
        _latestSale = _saleName;
        assignedWalletToSale[_saleName] = _walletAddress;
        mintedWalletSupply[_saleName][_walletAddress] = _supply;
        emit MintedWalletSuupply(_saleName, _supply, _walletAddress);
    }

    /***
     * @function getPerSaleWalletSupply
     * @dev return minted supply on a assgined wallet to a sale.
     */
    function getAssignedWalletAndSupply(
        string memory saleName
    ) public view returns (uint256, address) {
        address walletAddress = assignedWalletToSale[saleName];
        uint256 mintedSupply = mintedWalletSupply[saleName][walletAddress];
        return (mintedSupply, walletAddress);
    }

    /***
     * @function getDefaultSale
     * @dev Get default sale name on other contracts
     */
    function getLatestSale() public view returns (string memory) {
        return _latestSale;
    }

    /***
     * @function getMaxSupply
     * @dev returns maxTotalSupply variable
     */
    function getMaxSupply() public pure returns (uint160) {
        return MAX_TOTAL_SUPPLY;
    }


        /**
     * @dev Authorizes an upgrade of the contract's implementation.
     * @param newImplementation The address of the new implementation contract.
     * @notice Only callable by the owner.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override onlyOwner {}
}

