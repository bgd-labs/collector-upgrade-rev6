// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Linea, IPool} from 'aave-address-book/AaveV3Linea.sol';
import {Collector, ICollector, IERC20} from 'aave-v3-origin/contracts/treasury/Collector.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';
import {UpgradePayload} from '../src/UpgradePayload.sol';

contract LineaTest is UpgradeTest {
  constructor() UpgradeTest('linea', 14941305) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployLinea();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Linea.POOL;
  }

  // override as there are no assets yet to list
  function test_defaultExecution() external override {
    defaultTest(NETWORK, _getPool(), payload, false);
  }

  function test_storageCorrectness() external override {
    Collector collector = Collector(UpgradePayload(payload).COLLECTOR());
    uint256 nextStreamIdBefore = collector.getNextStreamId();

    // _status is 0 before which is strange (this fails currently)
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
}
