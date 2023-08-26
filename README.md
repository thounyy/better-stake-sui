These are the notes I took during research & development.
# Better Stake Sui

## Concept

> A community-based Liquid Staking Protocol, fully decentralized, permissionless, and composable, designed to elevate the transparency, decentralization, and performance of the Sui network. 

Protocol:
- *permissionlessness:* same staking requirements as natively staking SUI
- *decentralization:* can stake with any validator
- *composability:* everything is calculated and accessible onchain

Users will be incentivized to assess validators directly on-chain, guiding everyone toward more informed delegation decisions. The incentive will be gamified using dynamic NFTs (could have an image) that carry a progressive score/points metric. As users become more engaged, their score surges, leading to reduced fees during unstaking. 

At first, users who want to delegate will have to make their own validator selection based on community evaluations. Then, an additional automated mode could be implemented, optimizing stake delegation to boost decentralization and maximize APY. Eventually the protocol could evolve in a DAO governed by users with votes weighted according to points (engagement).

Score (automatically calculated):
- jurisdiction
- uptime
- commission 
- reputation
- % of the network validated
- (team)
- Reference Gas Price (RGP)

Social (selected by users):
- The validator contributes to the same communities as you
- The validator has built free Web3 tools you've found useful
- The validator has helped you with a DeFi or crypto question personally.
- The validator belongs to a DAO that you are a part of and want to support.
- The validator is giving you benefits for your support.
- You want to further support the validator's high performance or commission model
- You've noticed the validator advocate for Sui in other channels

## Design

1. User arrives on the dapp 
	1. Dashboard with stats
	2. Ranking of validators with info and ratings
2. Connects and stakes for the first time (choosing validator)
	1. Creates `BetterStake` Object with points and vector of StakedSui
	2. Returns betterSUI to use in DeFi
	3. Warn that currently the user is subject to 10% fee on withdrawal but he can evaluate validators to get up to 0% fee
4. On validators page, can rate them to increase points. Info on Dapp will be addresses, names and links to explorers 
5. Unstakes by sending `BetterStake` and correct amount of `BSUI` to get back initial SUI + rewards - fees (from points)

![Flow excalidraw](https://github.com/thounyy/better-stake-sui/assets/92447129/f9a6cf51-fc11-47f2-82c2-97ca7d3eb494)
