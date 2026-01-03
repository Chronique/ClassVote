// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ClassVote {
    address public admin;
    bool public pollCreated;
    
    struct Poll {
        string question;
        string candidate1;
        string candidate2;
        uint256 votes1;
        uint256 votes2;
    }

    Poll public activePoll;
    mapping(address => bool) public isWhitelisted;
    mapping(address => bool) public hasVoted;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Hanya Guru/Admin yang bisa");
        _;
    }

    // Fungsi untuk Admin mendaftarkan murid (Whitelist)
    function addToWhitelist(address[] calldata students) external onlyAdmin {
        for(uint i = 0; i < students.length; i++) {
            isWhitelisted[students[i]] = true;
        }
    }

    function createPoll(string calldata _q, string calldata _c1, string calldata _c2) external onlyAdmin {
        require(!pollCreated, "Polling sudah dibuat sebelumnya");
        activePoll = Poll(_q, _c1, _c2, 0, 0);
        pollCreated = true;
    }

    function vote(uint256 option) external {
        require(isWhitelisted[msg.sender], "Kamu tidak terdaftar di Whitelist");
        require(!hasVoted[msg.sender], "Kamu sudah memilih sebelumnya");
        require(pollCreated, "Polling belum dimulai");
        
        if (option == 1) activePoll.votes1++;
        else if (option == 2) activePoll.votes2++;
        
        hasVoted[msg.sender] = true;
    }
}