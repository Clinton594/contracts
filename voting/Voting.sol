// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

contract Voting{
    // Set the address that deployed the contract
  address admin;
    // define candicated to be voted in a struct
  struct Candidate {
      bytes32 name;
      uint32 votes;
      bool exists;
  }

//   Store my candidates in a map
  Candidate[] candidates;
//   Save my voters in a seperate mapping
  mapping(address => bool) voters;

  event Voted(
      address voter,
      uint32 candidate
  );

// Require that only admin can perform some operations
  modifier onlyAdmin(){
      require(admin == msg.sender, "ONLY_ADMIN_OPERATION");
      _;
  }

  constructor(){
    //   Set the address that deployed the contract as the admin
      admin = msg.sender;
  }

  function addCandidate(bytes32 _name) external onlyAdmin(){
    //   Create a new Struct for the candidate
    Candidate memory _newCandidate = Candidate(_name, 0, true);
    // Push candidate to the array of candidates
    candidates.push(_newCandidate);
  }

  function vote(uint32 _candidate) external payable {
    //   Grab the address of the voter
      address _voter = msg.sender;
    //   Check if voter has voted before
      require(voters[_voter], "CAN'T_VOTE_MORE_THAN_ONCE");
    //   Check if the voter is voting a valid candidate
      require(candidates[_candidate].exists, "CANDIDATE_TO_BE_VOTED_EXISTS");
    
    // Increment vote for the candidate
      candidates[_candidate].votes++;
    //    Record the voter
      voters[_voter] = true;
    //   Emit an event to front end
      emit Voted(_voter, _candidate);
  }
}