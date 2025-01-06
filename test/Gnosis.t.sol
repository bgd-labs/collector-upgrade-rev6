// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Gnosis, IPool} from 'aave-address-book/AaveV3Gnosis.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract GnosisTest is UpgradeTest {
  constructor() UpgradeTest('gnosis', 37905990) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployGnosis();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Gnosis.POOL;
  }
}
