// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3BNB, IPool} from 'aave-address-book/AaveV3BNB.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract BNBTest is UpgradeTest {
  constructor() UpgradeTest('bnb', 45531721) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployBNB();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3BNB.POOL;
  }
}
