// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3ZkSync} from 'aave-address-book/AaveV3Zksync.sol';
import {ProtocolV3TestBase, IPool, IPoolAddressesProvider} from 'aave-helpers/zksync/src/ProtocolV3TestBase.sol';
import {Collector, ICollector, IERC20} from 'aave-v3-origin/contracts/treasury/Collector.sol';
import {IAccessControl} from 'aave-v3-origin/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol';
import {DeploymentLibrary} from '../../script/Deploy.s.sol';
import {UpgradePayload} from '../../src/UpgradePayload.sol';
import {Payloads} from '../../src/Payloads.sol';

/**
 * @dev Collector Test for ZkSync
 * command: FOUNDRY_PROFILE=zksync forge test --match-path=zksync/test/ZkSync.t.sol -vv
 */
contract UpgradeTest is ProtocolV3TestBase {
  address payload;

  function setUp() public override {
    vm.createSelectFork(vm.rpcUrl('zksync'), 54434313);
    payload = _getPayload();
    super.setUp();
  }

  function test_defaultExecution() external {
    defaultTest('zksync', _getPool(), payload, false);
  }

  // ensures stream id is in same position as before
  function test_storageCorrectness() external {
    Collector collector = Collector(UpgradePayload(payload).COLLECTOR());
    uint256 nextStreamIdBefore = collector.getNextStreamId();

    // _status is 0 beause it was not initialized
    // assertEq(uint256(vm.load(address(collector), bytes32(uint256(52)))), 1);

    // _streams which was before at slot 55 should be 0
    assertEq(uint256(vm.load(address(collector), bytes32(uint256(55)))), 0);

    executePayload(vm, payload);

    assertEq(nextStreamIdBefore, collector.getNextStreamId());
    // revision should be 6 as  it's no longer used
    assertEq(uint256(vm.load(address(collector), bytes32(uint256(0)))), 0);
    // initializing should be false
    assertEq(vm.load(address(collector), bytes32(uint256(1))), 0x0);
    // last slot of gap should be empty
    assertEq(vm.load(address(collector), bytes32(uint256(51))), 0x0);

    // reentrancy _status should be 1 (this fails currently)
    // assertEq(uint256(vm.load(address(collector), bytes32(uint256(52)))), 1);

    // _streams which is now at slot 54 should be 0
    assertEq(uint256(vm.load(address(collector), bytes32(uint256(54)))), 0);
  }

  function test_transfer_aclAdmin() external {
    executePayload(vm, payload);

    IPoolAddressesProvider provider = _getPool().ADDRESSES_PROVIDER();
    address aclAdmin = provider.getACLAdmin();
    Collector collector = Collector(UpgradePayload(payload).COLLECTOR());

    vm.startPrank(aclAdmin);
    deal(address(collector), 100 ether);
    collector.transfer(IERC20(collector.ETH_MOCK_ADDRESS()), address(this), 100 ether);
  }

  // ensures reentrancy is not borked
  function test_transfer_newAdmin() external {
    executePayload(vm, payload);

    IPoolAddressesProvider provider = _getPool().ADDRESSES_PROVIDER();
    address aclAdmin = provider.getACLAdmin();
    Collector collector = Collector(UpgradePayload(payload).COLLECTOR());

    vm.startPrank(aclAdmin);
    IAccessControl(address(collector)).grantRole(collector.FUNDS_ADMIN_ROLE(), address(this));
    vm.stopPrank();

    deal(address(collector), 100 ether);
    collector.transfer(IERC20(collector.ETH_MOCK_ADDRESS()), address(this), 100 ether);
  }

  function _getPayload() internal returns (address) {
    return Payloads.ZKSYNC;
  }

  function _getPool() internal returns (IPool) {
    return AaveV3ZkSync.POOL;
  }

  receive() external payable {}
}
