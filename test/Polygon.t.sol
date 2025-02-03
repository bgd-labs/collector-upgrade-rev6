// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Polygon, IPool} from 'aave-address-book/AaveV3Polygon.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract PolygonTest is UpgradeTest {
  constructor() UpgradeTest('polygon', 67486745) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.POLYGON;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Polygon.POOL;
  }
}
