// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ITransparentUpgradeableProxy, ProxyAdmin} from "solidity-utils/contracts/transparent-proxy/TransparentUpgradeableProxy.sol";
import {IAccessControl} from "aave-v3-origin/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol";
import {Collector} from "aave-v3-origin/contracts/treasury/Collector.sol";

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
        // upgrade collector implementation with custom initialize to align storage
        ProxyAdmin(PROXY_ADMIN).upgradeAndCall(
            ITransparentUpgradeableProxy(COLLECTOR),
            COLLECTOR_IMPL,
            abi.encodeWithSelector(
                Collector.initialize.selector,
                0,
                address(this)
            )
        );
        // grant funds admin permissions to the executor
        IAccessControl(COLLECTOR).grantRole(
            Collector(COLLECTOR).FUNDS_ADMIN_ROLE(),
            address(this)
        );
    }
}
