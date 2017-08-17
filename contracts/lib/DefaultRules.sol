pragma solidity ^0.4.15;

import "lib/IRules.sol";


contract DefaultRules is IRules {
    function canPropose(address _sender, uint256 _proposalID) public constant returns (bool) {
        return false;
    }

    function canVote(address _sender, uint256 _proposalID) public constant returns (bool)  {
        return false;
    }

    function canExecute(address _sender, uint256 _proposalID) public constant returns (bool)  {
        return false;
    }

    function votingWeightOf(address _sender, uint256 _proposalID, uint256 _index, uint256 _data) public constant returns (uint256)  {
        return 1;
    }

    function voteOffset(address _sender, uint256 _proposalID) public constant returns (uint256)  {
        return 0;
    }

    function executionOffset(address _sender, uint256 _proposalID) public constant returns (uint256) {
        return 0;
    }
}
