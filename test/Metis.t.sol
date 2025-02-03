// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Metis, IPool} from 'aave-address-book/AaveV3Metis.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract MetisTest is UpgradeTest {
  constructor() UpgradeTest('metis', 19641278) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.METIS;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Metis.POOL;
  }
}
