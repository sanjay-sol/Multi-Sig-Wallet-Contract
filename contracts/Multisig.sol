// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Multi {
    event Deposit(address indexed sender, uint indexed amount);
    event Submit(uint indexed txnId);
    event Approve(address indexed owner, uint indexed txnId);
    event Revoke(address indexed owner, uint indexed txnId);
    event Execute(uint indexed txnId);
    
    mapping(address => bool) public isOwner;
    uint public minOwners;
    address[] public owners;
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    Transaction[] public transactions;
    // which owner approved which transaction
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner(){
        require(isOwner[msg.sender], "Only owner can call this function");
        _;
    }
    modifier txnExist(uint _txnId){
        require(_txnId < transactions.length, "Txn does not exist");
        _;
    }

    modifier notApproved(uint _txnId){
        require(!approved[_txnId][msg.sender], "Txn already approved");
        _;
    }
    modifier notExec(uint _txnId){
        require(!transactions[_txnId].executed, "Txn already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "Required atleast 1 owner");
        require( _required > 0 && _required <= _owners.length, "Invalid minimum owners condition");
        for(uint i; i < _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Duplicate owner address");

            isOwner[owner] = true;
            owners.push(owner);
        }
        minOwners = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }

    function approve(uint _txnId)
    external 
    onlyOwner
    txnExist(_txnId)
    notApproved(_txnId)
    notExec(_txnId)
    {
        approved[_txnId][msg.sender] = true;
        emit Approve(msg.sender, _txnId);
    }

    function _getApprovalCount(uint _txnId) private view returns (uint count) {
        for(uint i; i < owners.length; i++){
            if(approved[_txnId][owners[i]]){
                count += 1;
            }
        }
    }

    function execute(uint _txnId) external txnExist(_txnId) notExec(_txnId) {
        require(_getApprovalCount(_txnId) >= minOwners, "Minimum approvals required");
        Transaction storage txn = transactions[_txnId];
        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(
            txn.data
        );
        require(success, "txn failed");
        emit Execute(_txnId);


    }

    function revoke(uint _txnId) external onlyOwner txnExist(_txnId) notExec(_txnId) {
        require(approved[_txnId][msg.sender], "Txn not even approved");
        approved[_txnId][msg.sender] = false;
        emit Revoke(msg.sender, _txnId);
    } 

}