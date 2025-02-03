// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Scroll, IPool} from 'aave-address-book/AaveV3Scroll.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract ScrollTest is UpgradeTest {
  constructor() UpgradeTest('scroll', 13165814) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.SCROLL;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Scroll.POOL;
  }
}
