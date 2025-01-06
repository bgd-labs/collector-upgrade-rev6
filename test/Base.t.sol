// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Base, IPool} from 'aave-address-book/AaveV3Base.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract BaseTest is UpgradeTest {
  constructor() UpgradeTest('base', 24693420) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployBase();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Base.POOL;
  }
}
