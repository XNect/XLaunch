// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./XLaunch.sol";

contract XLaunchFactory is
    Initializable,
    OwnableUpgradeable,
    AccessControlUpgradeable
{
    using EnumerableMap for EnumerableMap.Bytes32ToAddressMap;
    address public WETH;
    address public ammRouter;
    address public ammFactory;
    address public beacon;
    EnumerableMap.Bytes32ToAddressMap private xLaunches;

    event Created(
        address indexed launch,
        address tokenAddress,
        string name,
        string symbol
    );

    function initialize(
        address _owner,
        address _WETH,
        address _ammRouter,
        address _ammFactory,
        address _beacon
    ) public initializer {
        __Ownable_init(_owner);
        __AccessControl_init();
        WETH = _WETH;
        ammRouter = _ammRouter;
        ammFactory = _ammFactory;
        beacon = _beacon;
    }

    function create(
        string memory _name,
        string memory _symbol,
        uint256 _hardCap,
        uint256 _duration,
        uint256 _tokenSupply
    ) public onlyOwner {
        bytes32 launchNameHash = keccak256(abi.encodePacked(_name));
        require(!xLaunches.contains(launchNameHash), "Launch already exists");
        bytes memory data = abi.encodeWithSignature(
            "initialize(address,address,address,address,uint256,uint256,uint256,string,string)",
            owner(),
            WETH,
            ammRouter,
            ammFactory,
            _hardCap,
            _duration,
            _tokenSupply,
            _name,
            _symbol
        );
        BeaconProxy proxy = new BeaconProxy(beacon, data);
        xLaunches.set(launchNameHash, address(proxy));
        emit Created(
            address(proxy),
            address(XLaunch(address(proxy)).token()),
            _name,
            _symbol
        );
    }

    function getXLaunchByName(
        string memory _name
    ) public view returns (address) {
        return xLaunches.get(keccak256(abi.encodePacked(_name)));
    }

    function getXLaunchByIndex(uint256 _index) public view returns (address) {
        (, address value) = xLaunches.at(_index);
        return value;
    }

    function getXLaunchesLength() public view returns (uint256) {
        return xLaunches.length();
    }
}
