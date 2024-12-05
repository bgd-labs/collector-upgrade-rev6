// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MiscEthereum} from "aave-address-book/MiscEthereum.sol";
import {AaveV3Ethereum} from "aave-address-book/AaveV3Ethereum.sol";

import {MiscPolygon} from "aave-address-book/MiscPolygon.sol";
import {AaveV3Polygon} from "aave-address-book/AaveV3Polygon.sol";

import {GovV3Helpers} from "aave-helpers/src/GovV3Helpers.sol";
import {CollectorWithCustomImpl} from "../src/CollectorWithCustomImpl.sol";
import {UpgradePayload} from "../src/UpgradePayload.sol";

library DeploymentLibrary {
    function _deploy(
        address aclManager,
        address collector,
        address proxyAdmin
    ) private returns (address) {
        address impl = GovV3Helpers.deployDeterministic(
            type(CollectorWithCustomImpl).creationCode,
            abi.encode(aclManager)
        );
        CollectorWithCustomImpl(impl).initialize(0);
        return address(new UpgradePayload(collector, impl, proxyAdmin));
    }

    function deployMainnet() internal returns (address) {
        return
            _deploy(
                address(AaveV3Ethereum.ACL_MANAGER),
                address(AaveV3Ethereum.COLLECTOR),
                MiscEthereum.PROXY_ADMIN
            );
    }

    function deployPolygon() internal returns (address) {
        return
            _deploy(
                address(AaveV3Polygon.ACL_MANAGER),
                address(AaveV3Polygon.COLLECTOR),
                MiscPolygon.PROXY_ADMIN
            );
    }
}
