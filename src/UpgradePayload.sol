// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ITransparentUpgradeableProxy, ProxyAdmin} from "solidity-utils/contracts/transparent-proxy/TransparentUpgradeableProxy.sol";
import {ICollector} from "aave-v3-origin/contracts/treasury/Collector.sol";

contract UpgradePayload {
    address public immutable PROXY_ADMIN;
    address public immutable COLLECTOR;
    address public immutable COLLECTOR_IMPL;

    constructor(address collector, address collectorImpl, address proxyAdmin) {
        COLLECTOR = collector;
        COLLECTOR_IMPL = collectorImpl;
        PROXY_ADMIN = proxyAdmin;
    }

    function execute() external {
        ProxyAdmin(PROXY_ADMIN).upgradeAndCall(
            ITransparentUpgradeableProxy(COLLECTOR),
            COLLECTOR_IMPL,
            abi.encodeWithSelector(ICollector.initialize.selector, 0)
        );
    }
}
