// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Metis, IPool} from 'aave-address-book/AaveV3Metis.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract MetisTest is UpgradeTest {
  constructor() UpgradeTest('metis', 19394504) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployMetis();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Metis.POOL;
  }
}
