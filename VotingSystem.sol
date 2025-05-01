// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    struct Voter {
        bool hasVoted;
        uint256 votedFor;
    }
    
    address public admin;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    bool public votingOpen;
    uint256 public votingStart;
    uint256 public votingEnd;
    
    event VoteCast(address indexed voter, uint256 candidateId);
    event CandidateAdded(string name, uint256 candidateId);
    event VotingStarted(uint256 startTime, uint256 endTime);
    event VotingEnded(uint256 endTime);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier votingIsOpen() {
        require(votingOpen, "Voting is not open");
        require(block.timestamp >= votingStart && block.timestamp <= votingEnd, "Voting period has ended");
        _;
    }
    
    constructor() {
        admin = msg.sender;
        votingOpen = false;
    }
    
    function addCandidate(string memory _name) public onlyAdmin {
        require(!votingOpen, "Cannot add candidate after voting has started");
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(_name, candidates.length - 1);
    }
    
    function startVoting(uint256 _durationInMinutes) public onlyAdmin {
        require(!votingOpen, "Voting is already open");
        require(_durationInMinutes > 0, "Duration must be greater than 0");
        require(candidates.length >= 2, "Need at least 2 candidates");
        
        votingStart = block.timestamp;
        votingEnd = votingStart + (_durationInMinutes * 1 minutes);
        votingOpen = true;
        
        emit VotingStarted(votingStart, votingEnd);
    }
    
    function vote(uint256 _candidateId) public votingIsOpen {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");
        
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedFor = _candidateId;
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }
    
    function endVoting() public onlyAdmin {
        require(votingOpen, "Voting is not open");
        require(block.timestamp >= votingEnd, "Voting period has not ended yet");
        
        votingOpen = false;
        emit VotingEnded(block.timestamp);
    }
    
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }
    
    function getCandidate(uint256 _candidateId) public view returns (string memory name, uint256 voteCount) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }
    
    function getVotingStatus() public view returns (bool isOpen, uint256 timeRemaining) {
        if (!votingOpen || block.timestamp >= votingEnd) {
            return (false, 0);
        }
        return (true, votingEnd - block.timestamp);
    }
} 