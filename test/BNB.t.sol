// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3BNB, IPool} from 'aave-address-book/AaveV3BNB.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract BNBTest is UpgradeTest {
  constructor() UpgradeTest('bnb', 46021455) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.BNB;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3BNB.POOL;
  }
}
