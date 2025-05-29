// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "./XToken.sol";
import "./interface/IPancake.sol";

contract XLaunch is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{
    uint256 public startTime;
    uint256 public endTime;
    uint256 public hardCap;
    uint256 public tokenSupply;
    uint256 public userCount;

    address public WETH;
    address public ammRouter;
    address public ammFactory;
    address public belongTo;

    XToken public token;
    uint256 public poolSupply;
    uint256 public userSupply;
    uint256 public ownerSupply;
    uint256 public poolCreatedTimestamp;
    address public poolAddress;

    uint256 public totalDeposits;
    uint256 public constant minDeposit = 0.01 ether;
    mapping(address => uint256) public deposits;
    mapping(address => bool) public isClaimed;
    bool public isBelongToClaimed = false;
    bool public isEnded = false;

    event Deposit(address indexed user, uint256 amount);
    event Claim(address indexed user, uint256 tokenAmount, uint256 refund);
    event Ended(address indexed poolAddress, uint256 totalDeposits);
    event OwnerClaimed(address indexed belongTo, uint256 amount);

    function initialize(
        address _owner,
        address _WETH,
        address _ammRouter,
        address _ammFactory,
        uint256 _hardCap,
        uint256 _duration,
        uint256 _tokenSupply,
        string memory _name,
        string memory _symbol
    ) public initializer {
        __Ownable_init(_owner);
        __ReentrancyGuard_init();
        WETH = _WETH;
        ammRouter = _ammRouter;
        ammFactory = _ammFactory;
        hardCap = _hardCap;
        tokenSupply = _tokenSupply;
        startTime = block.timestamp;
        endTime = startTime + _duration;

        token = new XToken(_name, _symbol);
        token.mint(address(this), tokenSupply);
        poolSupply = tokenSupply / 3;
        userSupply = tokenSupply / 3;
        ownerSupply = tokenSupply - poolSupply - userSupply;
    }

    function deposit() public payable nonReentrant {
        require(block.timestamp < endTime, "Launch is over");
        require(
            msg.value >= minDeposit,
            "Deposit amount must be greater than 0.01 ether"
        );
        if (deposits[msg.sender] == 0) {
            userCount++;
        }
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function claim() public nonReentrant {
        require(isEnded, "Launch is not over");
        require(deposits[msg.sender] > 0, "No deposits");
        require(!isClaimed[msg.sender], "Already claimed");
        isClaimed[msg.sender] = true;
        (uint256 tokenAmount, uint256 refund) = getClaimable(msg.sender);
        safeTokenTransfer(msg.sender, tokenAmount);
        if (refund > 0) {
            safeNativeTransfer(msg.sender, refund);
        }
        emit Claim(msg.sender, tokenAmount, refund);
    }

    function ownerClaim() public {
        require(msg.sender == belongTo, "Not belong to you");
        require(isEnded, "Launch is not over");
        require(!isBelongToClaimed, "Already claimed");
        isBelongToClaimed = true;
        safeTokenTransfer(belongTo, ownerSupply);
        emit OwnerClaimed(belongTo, ownerSupply);
    }

    function migrate() public {
        require(block.timestamp > endTime, "Launch is not over");
        require(
            block.timestamp >= endTime + 24 hours || msg.sender == owner(),
            "Only owner can call within 24 hours after endTime"
        );
        require(!isEnded, "Launch is ended");
        require(totalDeposits > 0, "No ETH to add liquidity");

        isEnded = true;
        token.approve(ammRouter, poolSupply);
        IPancakeRouter(ammRouter).addLiquidityETH{value: totalDeposits}(
            address(token),
            poolSupply,
            poolSupply,
            totalDeposits,
            0x0000000000000000000000000000000000000000, // transfer to zero address
            type(uint256).max
        );
        poolAddress = IPancakeFactory(ammFactory).getPair(address(token), WETH);
        poolCreatedTimestamp = block.timestamp;
        emit Ended(poolAddress, totalDeposits);
    }

    function getClaimable(
        address user
    ) public view returns (uint256 claimable, uint256 refund) {
        if (totalDeposits == 0) {
            return (0, 0);
        }

        uint256 userDeposit = deposits[user];
        if (userDeposit == 0) {
            return (0, 0);
        }
        claimable = (userDeposit * userSupply) / totalDeposits;
        if (totalDeposits > hardCap) {
            refund = userDeposit - ((userDeposit * hardCap) / totalDeposits);
        }
    }

    function setBelongTo(address _belongTo) public onlyOwner {
        belongTo = _belongTo;
    }

    function safeTokenTransfer(address to, uint256 amount) private {
        if (amount > token.balanceOf(address(this))) {
            amount = token.balanceOf(address(this));
        }
        token.transfer(to, amount);
    }

    function safeNativeTransfer(address to, uint256 amount) private {
        if (amount > address(this).balance) {
            amount = address(this).balance;
        }
        payable(to).transfer(amount);
    }
}
