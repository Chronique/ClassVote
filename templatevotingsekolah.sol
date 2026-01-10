/**
 *Submitted for verification at basescan.org on 2026-01-09
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SMP21Voting {
    struct Candidate {
        string name;
        string photoUrl;
        uint256 voteCount;
    }

    // --- STATE VARIABLES ---
    address public owner;
    string public pollTitle = "PEMILIHAN KETUA KELAS"; 
    uint256 public pollId; 
    bool public pollCreated; 
    
    Candidate[] public candidates;
    
    mapping(address => bool) public isAdmin;
    address[] public adminAddresses; // Array untuk menyimpan daftar admin

    mapping(address => bool) public whitelist; 
    address[] public whitelistAddresses; // Array untuk menyimpan daftar pemilih

    mapping(uint256 => mapping(address => bool)) public hasVotedInPoll;

    // --- EVENTS ---
    event PollCreated(uint256 indexed id, string title);
    event Voted(uint256 indexed id, address voter, uint256 candidateIndex);

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Hanya Admin yang bisa akses");
        _;
    }

    constructor(address _admin1, address _admin2, address _admin3) {
        owner = msg.sender;
        
        // Daftarkan admin awal
        _addAdminInternal(msg.sender);
        _addAdminInternal(_admin1);
        _addAdminInternal(_admin2);
        _addAdminInternal(_admin3);
    }

    // --- FUNGSI INTERNAL ---

    // Fungsi pembantu agar pendaftaran admin tidak duplikat di array
    function _addAdminInternal(address _admin) internal {
        if (_admin != address(0) && !isAdmin[_admin]) {
            isAdmin[_admin] = true;
            adminAddresses.push(_admin);
        }
    }

    // --- FUNGSI ADMIN ---

    function addAdmin(address _admin) public onlyAdmin {
        require(_admin != address(0), "Alamat tidak valid");
        require(!isAdmin[_admin], "Sudah menjadi admin");
        _addAdminInternal(_admin);
    }

    function updateTitle(string memory _newTitle) public onlyAdmin {
        pollTitle = _newTitle;
    }

    function addToWhitelist(address[] memory _voters) public onlyAdmin {
        for (uint256 i = 0; i < _voters.length; i++) {
            address voter = _voters[i];
            if (voter != address(0) && !whitelist[voter]) {
                whitelist[voter] = true;
                whitelistAddresses.push(voter);
            }
        }
    }

    function createPoll(string[] memory _names, string[] memory _photos) public onlyAdmin {
        require(!pollCreated, "Reset dulu pemilihan sebelumnya");
        require(_names.length >= 2 && _names.length <= 5, "Minimal 2, Maksimal 5 kandidat");
        require(_names.length == _photos.length, "Data tidak sinkron");

        pollId++; 
        
        for (uint256 i = 0; i < _names.length; i++) {
            candidates.push(Candidate({
                name: _names[i],
                photoUrl: _photos[i],
                voteCount: 0
            }));
        }

        pollCreated = true;
        emit PollCreated(pollId, pollTitle);
    }

    function resetPoll(bool _clearWhitelist) public onlyAdmin {
        delete candidates;
        pollCreated = false;
        
        if (_clearWhitelist) {
            // Menghapus status whitelist di mapping berdasarkan daftar di array
            for (uint256 i = 0; i < whitelistAddresses.length; i++) {
                whitelist[whitelistAddresses[i]] = false;
            }
            // Mengosongkan array
            delete whitelistAddresses;
        }
    }

    // --- FUNGSI VOTING ---

    function vote(uint256 _candidateIndex) public {
        require(pollCreated, "Pemilihan belum aktif");
        require(whitelist[msg.sender], "Anda tidak terdaftar sebagai pemilih");
        require(!hasVotedInPoll[pollId][msg.sender], "Anda sudah memilih di sesi ini");
        require(_candidateIndex < candidates.length, "Kandidat tidak valid");

        candidates[_candidateIndex].voteCount++;
        hasVotedInPoll[pollId][msg.sender] = true; 

        emit Voted(pollId, msg.sender, _candidateIndex);
    }

    // --- FUNGSI VIEW (UNTUK UI) ---

    /**
     * @dev Mengembalikan daftar lengkap semua alamat Admin
     */
    function getFullAdmins() public view returns (address[] memory) {
        return adminAddresses;
    }

    /**
     * @dev Mengembalikan daftar lengkap semua alamat Murid (Whitelist)
     */
    function getFullWhitelist() public view returns (address[] memory) {
        return whitelistAddresses;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}