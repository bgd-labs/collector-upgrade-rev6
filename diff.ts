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

const getChainAlias = (chainId: number) => {
  return Object.keys(ChainId).find((key) => ChainId[key] === chainId);
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
    const sourceCommand = `cast etherscan-source --flatten --chain ${getChainAlias(CHAIN_ID)} -d ${destination} ${impl}`;
    execSync(sourceCommand);
  }

  const command = `mkdir -p diffs/${CHAIN_ID} && forge inspect --pretty ${destination}:Collector storage > diffs/${CHAIN_ID}/storage_${COLLECTOR}`;
  execSync(command);
}

async function diffReference() {
  execSync(`forge flatten src/CustomCollector.sol -o flattened/Collector.sol`);
  execSync(
    `forge inspect --pretty flattened/Collector.sol:Collector storage > diffs/storage_new`,
  );
}

(async function main() {
  diffReference();
  await snapshotPool(AaveV3Ethereum);
  // await snapshotPool(AaveV3Polygon);
  // await snapshotPool(AaveV3Avalanche);
})();
