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
    mapping(address => bool) public whitelist; 
    mapping(uint256 => mapping(address => bool)) public hasVotedInPoll;

    // --- EVENTS ---
    event PollCreated(uint256 indexed id, string title);
    event Voted(uint256 indexed id, address voter, uint256 candidateIndex);

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Hanya Admin yang bisa akses");
        _;
    }

    /**
     * @dev Constructor untuk mendaftarkan 4 admin sekaligus:
     * 1. Pengirim transaksi (Anda/Deployer)
     * 2. Admin Tambahan 1 (Misal: Guru A)
     * 3. Admin Tambahan 2 (Misal: Guru B)
     * 4. Admin Tambahan 3 (Misal: Kepala Sekolah)
     */
    constructor(address _admin1, address _admin2, address _admin3) {
        owner = msg.sender;
        isAdmin[msg.sender] = true; // Anda otomatis jadi admin
        
        // Daftarkan 3 admin tambahan jika alamatnya valid (bukan 0x0)
        if (_admin1 != address(0)) isAdmin[_admin1] = true;
        if (_admin2 != address(0)) isAdmin[_admin2] = true;
        if (_admin3 != address(0)) isAdmin[_admin3] = true;
    }

    // --- FUNGSI ADMIN ---

    // Tetap ada fungsi ini jika suatu saat ingin menambah admin ke-5, ke-6, dst.
    function addAdmin(address _admin) public onlyAdmin {
        isAdmin[_admin] = true;
    }

    function updateTitle(string memory _newTitle) public onlyAdmin {
        pollTitle = _newTitle;
    }

    function addToWhitelist(address[] memory _voters) public onlyAdmin {
        for (uint256 i = 0; i < _voters.length; i++) {
            whitelist[_voters[i]] = true;
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
            // Logika reset whitelist total bisa ditambahkan di sini jika diperlukan
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

    // --- FUNGSI VIEW ---
    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}