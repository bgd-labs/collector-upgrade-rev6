## Collector unification

The aave treasury is an upgradable contract that was first released in Aave V1.
Over time the contract has been upgraded 4 times, while at the same time collectors on other networks have been deployed.
This has resulted in a situation where the storage layouts of the different collectors are slightly different.
While this does not cause any issue, it makes upgrades cumbersome and complicated.

Karpatkey together with tokenlogic [have proposed](https://github.com/aave-dao/aave-v3-origin/pull/82) introducing some new functionality on the collector,
to provide some new functionality required for the proposed [FinancialStewards](https://governance.aave.com/t/arfc-aave-finance-steward/17570).

While the originally proposed code was fine, it would have required custom upgrade code for different networks making future updates even more complicated.
To resolve this issue once and for all, BGD Labs proposed a [small update](https://github.com/aave-dao/aave-v3-origin/pull/94) to the proposed code.
Instead of trying to account for different implementations, the Collector inheritance chain was fundamentally upgraded to rely on [`ERC-2701`](https://eips.ethereum.org/EIPS/eip-7201) based storage layout for initialization, access-control and reentrancy protection.
With these changes the inheritance chain no longer pollutes sequential storage slots, so the only thing left to do is aligning the contract specific storage slots (`_nextStreamId` and `_streams`).

After the upgrade all storage layouts will be 100% aligned and future upgrades can be applied simultaneous on every chain.

Specification:

- the UpgradePayload upgrades the collector implementation & grants the funds_admin role to the executor
- the Collector implementation implements a custom initialize which uses assembly to 1) clear previously used storage slots and 2) move the value of some other storage slots into their new position
