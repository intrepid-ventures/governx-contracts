pragma solidity ^0.4.15;

import "lib/Controller.sol";
import "lib/MembershipRegistry.sol";


contract AuthorityController is Controller, MembershipRegistry {
  mapping(uint256 => bool) public voteSubmitted;
  mapping(uint256 => uint256) public yesVotes;
  mapping(uint256 => uint256) public totalVotes;

  address public authority;
  uint256 public required;
  uint256 public minimumQuorum;

  string public constant name = "AuthorityController";
  string public constant version = "1.0";

  modifier onlyAuthority() { if (msg.sender == authority) _; }

  function AuthorityController(address _proxy, address[] _members, uint256 _minimumQuorum, uint256 _required, address _authority) {
    for (uint m = 0; m < _members.length; m++) {
      addMember(_members[m]);
    }

    authority = _authority;
    required = _required;
    minimumQuorum = _minimumQuorum;
    setProxy(_proxy);
  }

  function changeVariables(uint256 _required, uint256 _minimumQuorum) onlyProxy {
    required = _required;
    minimumQuorum = _minimumQuorum;
  }

  function canPropose(address _sender, uint256 _proposalID) public constant returns (bool) {
      return isMember(_sender);
  }

  function canVote(address _sender, uint256 _proposalID) public constant returns (bool)  {
      return isMember(_sender);
  }

  function canExecute(address _sender, uint256 _proposalID) public constant returns (bool)  {
      return isMember(_sender) && hasWon(_sender, _proposalID);
  }

  function votingWeightOf(address _sender, uint256 _proposalID, uint256 _index, uint256 _data) public constant returns (uint256)  {
    if (isMember(_sender))
      return 1;
  }

  // only authority can submit the votes
  function submitTally(uint256 _proposalID, uint256 _yesVotes, uint256 _totalVotes) public onlyAuthority {
    if (yesVotes[_proposalID] == 0 && _yesVotes != 0 && voteSubmitted[_proposalID] == false) {
      voteSubmitted[_proposalID] = true;
      yesVotes[_proposalID] = _yesVotes;
      totalVotes[_proposalID] = _totalVotes;
    }
  }

  // extra methods for UI
  function hasWon(address _sender, uint256 _proposalID) public constant returns (bool) {
    uint256 quorum = totalVotes[_proposalID];
    uint256 totalYesVotes = yesVotes[_proposalID];

    return quorum >= minimumQuorum && totalYesVotes >= required;
  }

  function hasFailed(address _sender, uint256 _proposalID) public constant returns (bool) {
    return false;
  }
}
