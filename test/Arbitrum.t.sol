// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, IPool} from 'aave-address-book/AaveV3Arbitrum.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract ArbitrumTest is UpgradeTest {
  constructor() UpgradeTest('arbitrum', 302191494) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.ARBITRUM;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Arbitrum.POOL;
  }
}
