# Decentralized Fundraising on Cardano (GoFundMe)

## Introduction

This document describes the technical design of a decentralized GoFundMe-style fundraising system on the Cardano blockchain.

**Campaign Creation**: Anyone can deploy a new campaign by specifying a fundraising goal (in lovelace), a deadline (POSIX time), and a description (external link).

**Parameterized Deployment**: The contract generates a unique address / validator script per campaign.

**Donations**: Anyone can contribute ADA to a campaign by consuming a UtXO in the contract and locking it back in with a higher ADA amount.

**Owner-Controlled Withdrawals**: The campaign owner (identified by their public key hash) can withdraw the accumulated funds when the goal is reached or the deadline has passed.


## Glossary

* `goal (Int)`: The fundraising goal expressed in lovelace.
* `deadline (Int)`: The POSIX time when the campaign ends.
* `owner (ByteArray)`: The public key hash of the campaign creator who can withdraw funds.
* `description (ByteArray)`: A link to an external source describing the campaign.
