// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Gnosis, IPool} from 'aave-address-book/AaveV3Gnosis.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract GnosisTest is UpgradeTest {
  constructor() UpgradeTest('gnosis', 38372447) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.GNOSIS;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Gnosis.POOL;
  }
}
