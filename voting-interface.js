// Example using ethers.js
const { ethers } = require("ethers");

async function setupVoting(contractAddress, signer) {
    const votingContract = new ethers.Contract(
        contractAddress,
        VotingSystem.abi,
        signer
    );
    
    // Add candidates
    await votingContract.addCandidate("Candidate 1");
    await votingContract.addCandidate("Candidate 2");
    
    // Start voting (30 minutes duration)
    await votingContract.startVoting(30);
    
    // Cast a vote
} 