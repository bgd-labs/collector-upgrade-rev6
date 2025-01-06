// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, IPool} from 'aave-address-book/AaveV3Arbitrum.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract ArbitrumTest is UpgradeTest {
  constructor() UpgradeTest('arbitrum', 292621343) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployArbitrum();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Arbitrum.POOL;
  }
}
