// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Collector, ICollector} from "aave-v3-origin/contracts/treasury/Collector.sol";

/**
 * @title Collector
 * Custom modifications of this implementation:
 * - the initialize function manually alters private storage slots via assembly
 * - storage slot 51 is reset to 0
 * - storage slot 52 is set to 1 (which is the default state of the reentrancy guard)
 * @author BGD Labs
 *
 */
contract CollectorWithCustomImplZkSync is Collector {
  function initialize(uint256, address admin) external virtual override initializer {
    assembly {
      sstore(0, 0) // this slot was revision, which is no longer used
      sstore(53, 100000) // this slot was _fundsAdmin, but is now _nextStreamId
      sstore(54, 0) // this slot was _nextStreamId, but is now _streams
    }
    __AccessControl_init();
    __ReentrancyGuard_init();
    _grantRole(DEFAULT_ADMIN_ROLE, admin);
  }
}
