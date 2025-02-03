// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Optimism, IPool} from 'aave-address-book/AaveV3Optimism.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract OptimismTest is UpgradeTest {
  constructor() UpgradeTest('optimism', 131490178) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.OPTIMISM;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Optimism.POOL;
  }
}
