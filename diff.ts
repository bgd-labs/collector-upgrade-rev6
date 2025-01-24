import { AaveV3ZkSync } from "@bgd-labs/aave-address-book";
import { AaveV3Base } from "@bgd-labs/aave-address-book";
import { AaveV3Optimism } from "@bgd-labs/aave-address-book";
import { AaveV3Arbitrum } from "@bgd-labs/aave-address-book";
import { AaveV3Gnosis } from "@bgd-labs/aave-address-book";
import { AaveV3BNB } from "@bgd-labs/aave-address-book";
import { AaveV3Scroll } from "@bgd-labs/aave-address-book";
import { AaveV3Metis } from "@bgd-labs/aave-address-book";
import { AaveV3Linea } from "@bgd-labs/aave-address-book";
import {
  AaveV3Avalanche,
  AaveV3Ethereum,
  AaveV3Polygon,
} from "@bgd-labs/aave-address-book";
import { getRPCUrl, ChainId } from "@bgd-labs/rpc-env";
import { execSync } from "child_process";
import { existsSync, readFileSync, writeFileSync } from "fs";
import { Client, createClient, getAddress, Hex, http } from "viem";
import { getStorageAt } from "viem/actions";

const CHAIN_ID_API_KEY_MAP = {
  [ChainId.mainnet]: process.env.ETHERSCAN_API_KEY_MAINNET,
  [ChainId.sepolia]: process.env.ETHERSCAN_API_KEY_MAINNET,
  [ChainId.polygon]: process.env.ETHERSCAN_API_KEY_POLYGON,
  [ChainId.zkEVM]: process.env.ETHERSCAN_API_KEY_ZKEVM,
  [ChainId.arbitrum]: process.env.ETHERSCAN_API_KEY_ARBITRUM,
  [ChainId.optimism]: process.env.ETHERSCAN_API_KEY_OPTIMISM,
  [ChainId.scroll]: process.env.ETHERSCAN_API_KEY_SCROLL,
  [ChainId.scroll_sepolia]: process.env.ETHERSCAN_API_KEY_SCROLL,
  [ChainId.bnb]: process.env.ETHERSCAN_API_KEY_BNB,
  [ChainId.base]: process.env.ETHERSCAN_API_KEY_BASE,
  [ChainId.base_sepolia]: process.env.ETHERSCAN_API_KEY_BASE,
  [ChainId.zksync]: process.env.ETHERSCAN_API_KEY_ZKSYNC,
  [ChainId.gnosis]: process.env.ETHERSCAN_API_KEY_GNOSIS,
  [ChainId.linea]: process.env.ETHERSCAN_API_KEY_LINEA,
};

const bytes32toAddress = (bytes32: Hex) => {
  return getAddress(`0x${bytes32.slice(26)}`);
};

const getImplementationStorageSlot = async (client: Client, address: Hex) => {
  return (await getStorageAt(client, {
    address,
    slot: "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
  })) as Hex;
};

async function snapshotPool({ CHAIN_ID, COLLECTOR }) {
  const client = createClient({ transport: http(getRPCUrl(CHAIN_ID)) });
  const impl = bytes32toAddress(
    await getImplementationStorageSlot(client, COLLECTOR),
  );
  const destination = `flattened/${CHAIN_ID}/${impl}.sol`;
  if (!existsSync(destination)) {
    const sourceCommand = `cast etherscan-source --flatten --chain ${CHAIN_ID} -d ${destination} ${impl} --etherscan-api-key ${CHAIN_ID_API_KEY_MAP[CHAIN_ID]}`;
    execSync(sourceCommand);
  }

  const command = `mkdir -p reports/${CHAIN_ID} && forge inspect --pretty ${destination}:Collector storage > reports/${CHAIN_ID}/storage_${COLLECTOR}`;
  execSync(command);
}

async function diffReference() {
  execSync(
    `forge flatten src/CollectorWithCustomImpl.sol -o flattened/Collector.sol`,
  );
  execSync(
    `forge inspect --pretty flattened/Collector.sol:Collector storage > reports/storage_new`,
  );
}

(async function main() {
  diffReference();
  await snapshotPool(AaveV3Ethereum);
  await snapshotPool(AaveV3ZkSync);
  await snapshotPool(AaveV3Polygon);
  await snapshotPool(AaveV3Avalanche);
  await snapshotPool(AaveV3Arbitrum);
  await snapshotPool(AaveV3Optimism);
  await snapshotPool(AaveV3Base);
  await snapshotPool(AaveV3Gnosis);
  await snapshotPool(AaveV3Metis);
  await snapshotPool(AaveV3BNB);
  await snapshotPool(AaveV3Scroll);
  await snapshotPool(AaveV3Linea);
})();
