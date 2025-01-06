// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Scroll, IPool} from 'aave-address-book/AaveV3Scroll.sol';
import {UpgradeTest} from './UpgradeTest.sol';
import {DeploymentLibrary} from '../script/Deploy.s.sol';

contract ScrollTest is UpgradeTest {
  constructor() UpgradeTest('scroll', 12497606) {}

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary.deployScroll();
  }

  function _getPool() internal virtual override returns (IPool) {
    return AaveV3Scroll.POOL;
  }
}
