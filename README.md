# XLAUNCH

Empowering X Accounts: Ushering in a New Era of Fan-Based Social Asset Tokenization.

## I. Product Positioning

X Launch is the world’s first decentralized platform specializing in **X account tokenization**. By transforming high-value X accounts into tradable on-chain tokens, we empower content creators to monetize their influence while giving fans and investors the opportunity to share in the growth of social assets. This creates a **win-win ecosystem** for creators, investors, and fans alike.

## II. Core Value Proposition

- **Monetization for Creators** – X account owners receive one-third of the total tokens for free, instantly unlocking the capital value of their accounts.
- **Early-Stage Investment Access** – Investors can buy high-potential account tokens and share in their future growth.
- **Guaranteed Liquidity** – Every token gets an automated PancakeSwap trading pool for seamless, instant trading.

## III. Feature Overview

### 1. Token Auction

- **Fixed-duration public auction** with predefined parameters upon approval
- Participants buy **one-third of tokens** using **$BNB**
- Smart contract protections:
  - Oversubscribed funds are **automatically refunded pro-rata** during token distribution
  - Winning bidders receive **exclusive allocation rights**

### 2. Liquidity Provision & Token Distribution

- **Automated smart contract execution**:
  - 100% of auction proceeds (BNB) paired with one-third of tokens to form the PancakeSwap liquidity pool
  - LP tokens are permanently locked to ensure long-term stability
- **For auction participants**:
  - Claim your token allocation (one-third of total supply) through the platform
- **For X account owners**:
  - Receive your one-third token allocation after completing OAuth verification

### 3. Open Trading Phase

- Tokens become tradable on PancakeSwap immediately following auction completion
- Auction participants can claim their token allocations and any eligible refunds through the platform

### 4. Token Allocation

Total fixed supply: **1 billion tokens**, allocated as follows:

- **Public Auction**: 1/3 sold to community bidders
- **Initial Liquidity**: 1/3 paired with auction proceeds to create PancakeSwap liquidity
- **Creator Reserve**: 1/3 allocated to the X account owner

## IV. Key Features Breakdown

| Feature Module          | Implementation                   | User Value                                      |
| ----------------------- | -------------------------------- | ----------------------------------------------- |
| Account Tokenization    | Tokenize any X account           | Convert social influence into on-chain assets   |
| BNB Fundraising         | Smart contract + hard cap        | Fair participation with capital protection      |
| Automated Market Making | Deep PancakeSwap integration     | Instant liquidity solving cold-start issues     |
| Owner Verification      | X OAuth login + on-chain binding | Decentralized authentication ensuring ownership |

## VI. Technical Highlights

- Secure Smart Contracts: Audited fundraising contracts with auto-refund functionality
- Cross-Platform Integration: X OAuth login + automated PancakeSwap liquidity deployment
- On-Chain Transparency: All token distributions verifiable via BSC blockchain explorer

## VII. Key FAQs

**Q: Is there a fee to tokenize an account?**  
A: Completely free!

**Q: How are malicious accounts prevented?**  
A: Three-layer review system:

- Minimum follower/activity thresholds
- Manual content quality review
- Community reporting mechanism

**Q: How do account owners benefit?**  
A: Beyond receiving 33.3% tokens, they gain:

- Value appreciation from account influence growth
- Future creator royalties (transaction fee sharing)

## VIII. Smart Contract Development

### Installation

```shell
npm install
```

### Compile Contracts

```shell
npx hardhat compile
```
