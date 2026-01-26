// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SkillMatch {
    struct Job {
        address client;
        string description;
        uint256 budget;
        address freelancer;
        bool completed;
        bool paid;
    }

    mapping(uint256 => Job) public jobs;
    mapping(address => bytes32[]) public skills;
    uint256 public jobCount;

    event JobPosted(uint256 indexed jobId, address indexed client, uint256 budget);
    event JobAccepted(uint256 indexed jobId, address indexed freelancer);
    event JobCompleted(uint256 indexed jobId);

    error JobTaken();
    error NotFreelancer();

    function postJob(string memory description, uint256 budget) external payable returns (uint256) {
        uint256 jobId = jobCount++;
        jobs[jobId] = Job({
            client: msg.sender,
            description: description,
            budget: budget,
            freelancer: address(0),
            completed: false,
            paid: false
        });
        emit JobPosted(jobId, msg.sender, budget);
        return jobId;
    }

    function acceptJob(uint256 jobId) external {
        if (jobs[jobId].freelancer != address(0)) revert JobTaken();
        jobs[jobId].freelancer = msg.sender;
        emit JobAccepted(jobId, msg.sender);
    }

    function completeJob(uint256 jobId) external {
        if (jobs[jobId].freelancer != msg.sender) revert NotFreelancer();
        jobs[jobId].completed = true;
        emit JobCompleted(jobId);
    }

    function addSkill(bytes32 skill) external {
        skills[msg.sender].push(skill);
    }
}
