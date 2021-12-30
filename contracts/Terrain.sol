pragma solidity ^0.8.11;

// SPDX-License-Identifier: MIT

contract TerrainCrud {
    struct TerrainStruct {
        uint x1;
        uint y1;
        uint x2;
        uint y2;
        uint index;
    }

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // struct Proposal {
    //   uint id;
    // }

    // Declare array
    // Proposals[] proposal;

    uint public minimumPrice = 3;

    mapping(address => TerrainStruct) private terrainStructs;
    address[] private terrainIndex;

    Proposal[] proposals;

    event LogNewTerrain(address indexed userAddress, uint index, uint x1, uint y1, uint x2, uint y2);
    event LogUpdateTerrain(address indexed userAddress, uint index, uint x1, uint y1, uint x2, uint y2);

    //  function payForTerrain () public payable {
    //    require(msg.value > minimumPrice);
    //  }

    function isTerrain(address userAddress) public view returns (bool isIndeed) {
        if (terrainIndex.length == 0) return false;
        return (terrainIndex[terrainStructs[userAddress].index] == userAddress);
    }

    function insertTerrain(
        address userAddress,
        uint x1,
        uint y1,
        uint x2,
        uint y2
    ) public payable returns (uint index) {
        require(msg.value > minimumPrice);

        if (isTerrain(userAddress)) revert();
        terrainStructs[userAddress].x1 = x1;
        terrainStructs[userAddress].y1 = y1;
        terrainStructs[userAddress].x2 = x2;
        terrainStructs[userAddress].y2 = y2;
        terrainIndex.push(userAddress);
        terrainStructs[userAddress].index = terrainIndex.length - 1;

        //To be changed

        // // Reject if rectangle overlaps with input
        // require(x1 > terrainStructs[userAddress].x2 || terrainStructs[userAddress]._x1 > x2);
        // require(y1 > terrainStructs[userAddress].y2 || terrainStructs[userAddress]._y1 > y2);
        //To be changed

        emit LogNewTerrain(userAddress, terrainStructs[userAddress].index, x1, y1, x2, y2);
        return terrainIndex.length - 1;
    }

    function getTerrain(address userAddress)
        public
        view
        returns (
            uint x1,
            uint y1,
            uint x2,
            uint y2,
            uint index
        )
    {
        if (!isTerrain(userAddress)) revert();
        return (
            terrainStructs[userAddress].x1,
            terrainStructs[userAddress].y1,
            terrainStructs[userAddress].x2,
            terrainStructs[userAddress].y2,
            terrainStructs[userAddress].index
        );
    }

    function updateTerrain(
        address userAddress,
        uint x1,
        uint y1,
        uint x2,
        uint y2
    ) public onlyOwner returns (bool success) {
        if (!isTerrain(userAddress)) revert();

        terrainStructs[userAddress].x1 = x1;
        terrainStructs[userAddress].y1 = y1;
        terrainStructs[userAddress].x2 = x2;
        terrainStructs[userAddress].y2 = y2;
        emit LogUpdateTerrain(userAddress, terrainStructs[userAddress].index, x1, y1, x2, y2);
        return true;
    }

    function getTerrainCount() public view returns (uint count) {
        return terrainIndex.length;
    }

    function getTerrainAtIndex(uint index) public view returns (address userAddress) {
        return terrainIndex[index];
    }

    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
        // address delegate;
    }
    struct Proposal {
        uint id;
        uint voteCount; // could add other data about proposal
    }

    uint startTime;

    address chairperson;

    mapping(address => Voter) voters;
    //Proposal[] proposals;

    string public msgg;

    function addProposal(uint _terrain_id, uint voteCount) external {
        Proposal memory proposal = Proposal(_terrain_id, voteCount);

        proposals.push(proposal); // Member "push" not found or not visible after argument-dependent lookup in struct MyContract.Player memory.
    }

    /// Create a new ballot with $(_numProposals) different proposals.
    constructor(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        //proposals.length++;

        startTime = block.timestamp;
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        // if (stage != Stage.vote){return;}
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function approvedProposal() public view returns (uint8 _approvedProposal) {
        uint256 approvedVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > approvedVoteCount) {
                approvedVoteCount = proposals[prop].voteCount;
                _approvedProposal = prop;
                assert(_approvedProposal > 0);
            }
        return _approvedProposal;
    }
}
