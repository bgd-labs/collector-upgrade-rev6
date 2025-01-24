// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';

import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';

import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

import {MiscAvalanche} from 'aave-address-book/MiscAvalanche.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';

import {MiscBase} from 'aave-address-book/MiscBase.sol';
import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';

import {MiscMetis} from 'aave-address-book/MiscMetis.sol';
import {AaveV3Metis} from 'aave-address-book/AaveV3Metis.sol';

import {MiscBNB} from 'aave-address-book/MiscBNB.sol';
import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';

import {MiscScroll} from 'aave-address-book/MiscScroll.sol';
import {AaveV3Scroll} from 'aave-address-book/AaveV3Scroll.sol';

import {MiscGnosis} from 'aave-address-book/MiscGnosis.sol';
import {AaveV3Gnosis} from 'aave-address-book/AaveV3Gnosis.sol';

import {MiscZkSync} from 'aave-address-book/MiscZkSync.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

import {MiscLinea} from 'aave-address-book/MiscLinea.sol';
import {AaveV3Linea} from 'aave-address-book/AaveV3Linea.sol';

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {
  EthereumScript,
  LineaScript,
  PolygonScript,
  GnosisScript,
  BNBScript,
  ArbitrumScript,
  OptimismScript,
  BaseScript,
  AvalancheScript,
  ScrollScript,
  MetisScript,
  ZkSyncScript,
  Script
} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {CollectorWithCustomImpl} from '../src/CollectorWithCustomImpl.sol';
import {CollectorWithCustomImplNewLayout} from '../src/CollectorWithCustomImplNewLayout.sol';
import {UpgradePayload} from '../src/UpgradePayload.sol';

library DeploymentLibrary {
  function _deploy(address collector, address proxyAdmin) private returns (address) {
    address impl = GovV3Helpers.deployDeterministic(type(CollectorWithCustomImpl).creationCode);
    return address(new UpgradePayload(collector, impl, proxyAdmin));
  }

  function _deployNewLayout(address collector, address proxyAdmin) private returns (address) {
    address impl = address(new CollectorWithCustomImplNewLayout());
    return address(new UpgradePayload(collector, impl, proxyAdmin));
  }

  function deployMainnet() internal returns (address) {
    return _deploy(address(AaveV3Ethereum.COLLECTOR), MiscEthereum.PROXY_ADMIN);
  }

  function deployPolygon() internal returns (address) {
    return _deploy(address(AaveV3Polygon.COLLECTOR), MiscPolygon.PROXY_ADMIN);
  }

  function deployArbitrum() internal returns (address) {
    return _deploy(address(AaveV3Arbitrum.COLLECTOR), MiscArbitrum.PROXY_ADMIN);
  }

  function deployOptimism() internal returns (address) {
    return _deploy(address(AaveV3Optimism.COLLECTOR), MiscOptimism.PROXY_ADMIN);
  }

  function deployAvalanche() internal returns (address) {
    return _deploy(address(AaveV3Avalanche.COLLECTOR), MiscAvalanche.PROXY_ADMIN);
  }

  function deployBase() internal returns (address) {
    return _deploy(address(AaveV3Base.COLLECTOR), MiscBase.PROXY_ADMIN);
  }

  function deployMetis() internal returns (address) {
    return _deploy(address(AaveV3Metis.COLLECTOR), MiscMetis.PROXY_ADMIN);
  }

  function deployBNB() internal returns (address) {
    return _deploy(address(AaveV3BNB.COLLECTOR), MiscBNB.PROXY_ADMIN);
  }

  function deployScroll() internal returns (address) {
    return _deploy(address(AaveV3Scroll.COLLECTOR), MiscScroll.PROXY_ADMIN);
  }

  function deployGnosis() internal returns (address) {
    return _deploy(address(AaveV3Gnosis.COLLECTOR), MiscGnosis.PROXY_ADMIN);
  }

  function deployLinea() internal returns (address) {
    return _deployNewLayout(address(AaveV3Linea.COLLECTOR), MiscLinea.PROXY_ADMIN);
  }

  function deployZkSync() internal returns (address) {
    return _deployNewLayout(address(AaveV3ZkSync.COLLECTOR), MiscZkSync.PROXY_ADMIN);
  }
}

contract DeployMainnet is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary.deployMainnet();
  }
}

contract DeployScroll is ScrollScript {
  function run() external broadcast {
    DeploymentLibrary.deployScroll();
  }
}

contract DeployOptimism is OptimismScript {
  function run() external broadcast {
    DeploymentLibrary.deployOptimism();
  }
}

contract DeployArbitrum is ArbitrumScript {
  function run() external broadcast {
    DeploymentLibrary.deployArbitrum();
  }
}

contract DeployGnosis is GnosisScript {
  function run() external broadcast {
    DeploymentLibrary.deployGnosis();
  }
}

contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    DeploymentLibrary.deployPolygon();
  }
}

contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    DeploymentLibrary.deployAvalanche();
  }
}

contract DeployBase is BaseScript {
  function run() external broadcast {
    DeploymentLibrary.deployBase();
  }
}

contract DeployBNB is BNBScript {
  function run() external broadcast {
    DeploymentLibrary.deployBNB();
  }
}

contract DeployMetis is MetisScript {
  function run() external broadcast {
    DeploymentLibrary.deployMetis();
  }
}

contract DeployLinea is LineaScript {
  function run() external broadcast {
    DeploymentLibrary.deployLinea();
  }
}

contract DeployZksync is Script {
  function run() external {
    vm.startBroadcast();

    address impl = address(new CollectorWithCustomImplNewLayout());
    new UpgradePayload(address(AaveV3ZkSync.COLLECTOR), impl, MiscZkSync.PROXY_ADMIN);
    vm.stopBroadcast();
  }
}
