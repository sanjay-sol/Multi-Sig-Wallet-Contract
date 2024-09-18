# Multi-Signature Wallet Smart Contract

This repository contains the implementation of a Solidity-based **Multi-Signature Wallet** contract. This contract allows multiple owners to approve and manage transactions in a decentralized way. For a transaction to be executed, a minimum number of owners must approve it. 


## Features

- **Multi-Signature Approval**: Multiple owners can collectively approve and execute transactions.
- **Submit Transactions**: Any owner can propose a new transaction.
- **Approve Transactions**: Owners can approve submitted transactions.
- **Revoke Approval**: Owners can revoke their approval for a transaction.
- **Execute Transactions**: Transactions can only be executed after receiving a minimum number of approvals.
- **Deposit Ether**: The contract can hold Ether and execute transactions involving Ether transfers.

# Contract Overview

## Key Components

- **Owners**: A predefined group of addresses who are allowed to submit, approve, and execute transactions.
- **Transaction**: A request to transfer Ether or perform an action on another contract. Transactions are stored in the contract until a minimum number of owners approve them.
- **Approval**: An action where an owner agrees to execute a transaction.
- **Execution**: Once the required number of approvals is reached, any owner can execute the transaction.

## Contract Overview

### Events

- **Deposit**: Logged whenever Ether is deposited into the contract.
- **Submit**: Triggered when an owner submits a transaction.
- **Approve**: Triggered when an owner approves a transaction.
- **Revoke**: Triggered when an owner revokes their approval for a transaction.
- **Execute**: Triggered when a transaction is executed.

### Functions

- **submit(address _to, uint _value, bytes calldata _data)**: Submits a transaction to be approved by the owners.
- **approve(uint _txnId)**: Approves a submitted transaction.
- **execute(uint _txnId)**: Executes the transaction once the minimum number of owners have approved it.
- **revoke(uint _txnId)**: Revokes the approval of a transaction that hasn't been executed yet.
