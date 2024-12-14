// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, IPool} from 'aave-address-book/AaveV3Ethereum.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract MainnetTest is UpgradeTest {
  constructor() UpgradeTest('mainnet', 21336615) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployMainnet();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Ethereum.POOL;
  }
}
