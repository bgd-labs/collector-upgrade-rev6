// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Avalanche, IPool} from 'aave-address-book/AaveV3Avalanche.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract AvalancheTest is UpgradeTest {
  constructor() UpgradeTest('avalanche', 56763394) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.AVALANCHE;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Avalanche.POOL;
  }
}
