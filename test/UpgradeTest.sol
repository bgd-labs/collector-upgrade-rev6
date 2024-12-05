// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ProtocolV3TestBase, IPool, IPoolAddressesProvider} from "aave-helpers/src/ProtocolV3TestBase.sol";
import {Collector, ICollector, IERC20} from "aave-v3-origin/contracts/treasury/Collector.sol";
import {IAccessControl} from "aave-v3-origin/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol";
import {UpgradePayload} from "../src/UpgradePayload.sol";

/**
 * @dev Test for AaveV3EthereumLido_GHOListingOnLidoPool_20241119
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20241119_AaveV3EthereumLido_GHOListingOnLidoPool/AaveV3EthereumLido_GHOListingOnLidoPool_20241119.t.sol -vv
 */
abstract contract UpgradeTest is ProtocolV3TestBase {
    string public NETWORK;
    uint256 public immutable BLOCK_NUMBER;

    address payload;

    constructor(string memory network, uint256 blocknumber) {
        NETWORK = network;
        BLOCK_NUMBER = blocknumber;
    }

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
        payload = _getPayload();
    }

    function test_defaultExecution() external {
        defaultTest(NETWORK, _getPool(), payload);
    }

    // ensures stream id is in same position as before
    function test_storageCorrectness() external {
        Collector collector = Collector(UpgradePayload(payload).COLLECTOR());
        uint256 nextStreamIdBefore = collector.getNextStreamId();

        executePayload(vm, payload);

        assertEq(nextStreamIdBefore, collector.getNextStreamId());
        // revision should be 6
        assertEq(uint256(vm.load(address(collector), bytes32(uint256(0)))), 6);
        // initializing should be false
        assertEq(vm.load(address(collector), bytes32(uint256(1))), 0x0);
        // last slot of gap should be empty
        assertEq(vm.load(address(collector), bytes32(uint256(51))), 0x0);
        // reentrancy _status should be 1
        assertEq(uint256(vm.load(address(collector), bytes32(uint256(52)))), 1);
    }

    // ensures reentracy is not borked
    function test_transfer() external {
        executePayload(vm, payload);

        IPoolAddressesProvider provider = _getPool().ADDRESSES_PROVIDER();
        address aclAdmin = provider.getACLAdmin();
        address aclManager = provider.getACLManager();
        Collector collector = Collector(UpgradePayload(payload).COLLECTOR());

        vm.startPrank(aclAdmin);
        IAccessControl(aclManager).grantRole(
            collector.FUNDS_ADMIN_ROLE(),
            address(this)
        );
        vm.stopPrank();

        deal(address(collector), 100 ether);
        collector.transfer(
            IERC20(collector.ETH_MOCK_ADDRESS()),
            address(this),
            100 ether
        );
    }

    function _getPayload() internal virtual returns (address);

    function _getPool() internal virtual returns (IPool);

    receive() external payable {}
}
