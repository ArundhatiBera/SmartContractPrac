// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract Polling {
    struct Choice {
        string name;
        uint voteCount;
    }

    struct PollData {
        string question;
        Choice[] choices;
        mapping(address => bool) hasVoted;
    }

    PollData[] public polls;

    function createPoll(string memory question, string[] memory choiceNames) public {
        // Create a new poll and push it to the polls array
        PollData storage newPoll = polls.push();

        newPoll.question = question;

        for (uint i = 0; i < choiceNames.length; i++) {
            newPoll.choices.push(Choice({
                name: choiceNames[i],
                voteCount: 0
            }));
        }
    }

    function vote(uint pollIndex, uint choiceIndex) public {
        PollData storage poll = polls[pollIndex];
        
        require(!poll.hasVoted[msg.sender], "You have already voted.");
        require(choiceIndex < poll.choices.length, "Invalid choice.");

        poll.choices[choiceIndex].voteCount++;
        poll.hasVoted[msg.sender] = true;
    }

    function getPoll(uint pollIndex) public view returns (string memory question, string[] memory choiceNames, uint[] memory voteCounts) {
        PollData storage poll = polls[pollIndex];
        
        choiceNames = new string[](poll.choices.length);
        voteCounts = new uint[](poll.choices.length);
        
        for (uint i = 0; i < poll.choices.length; i++) {
            choiceNames[i] = poll.choices[i].name;
            voteCounts[i] = poll.choices[i].voteCount;
        }
        return (poll.question, choiceNames, voteCounts);
    }
}