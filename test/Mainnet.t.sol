// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, IPool} from 'aave-address-book/AaveV3Ethereum.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {Payloads} from '../src/Payloads.sol';

contract MainnetTest is UpgradeTest {
  constructor() UpgradeTest('mainnet', 21689101) {}

  function _getPayload() internal virtual override returns (address) {
    return Payloads.MAINNET;
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Ethereum.POOL;
  }
}
