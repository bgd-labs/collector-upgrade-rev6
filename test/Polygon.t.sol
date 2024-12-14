// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Polygon, IPool} from 'aave-address-book/AaveV3Polygon.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract PolygonTest is UpgradeTest {
  constructor() UpgradeTest('polygon', 65118236) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployPolygon();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Polygon.POOL;
  }
}
