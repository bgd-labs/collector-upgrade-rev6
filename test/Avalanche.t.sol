// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Avalanche, IPool} from 'aave-address-book/AaveV3Avalanche.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract AvalancheTest is UpgradeTest {
  constructor() UpgradeTest('avalanche', 55418905) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployAvalanche();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Avalanche.POOL;
  }
}
