// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// For Curve DAO

interface IAAVE {

    function balanceOf(address account) external view returns (uint);

}

contract AAVEProposal {

     address public proposal_maker;
     mapping(address=>bool) public has_voted;
     string public proposal_CID;
     mapping(address=>bool) public hasSubmittedZK;
     address  aavetoken = payable(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9) ;
     IAAVE aave = IAAVE(aavetoken);

     uint256[] public ZKHash ;

     uint8 nonceKeys = 0;
     uint8 nonceCID = 0;


     string public  privateKeyHash;
     string public  publicKeyHash;

     event Voted( address indexed voter, uint256 timestamp );
     event ProposalCreated ( address indexed maker, string indexed cid  ) ;
      require(aave.balanceOf(msg.sender) > 0, "Invalid User");

     modifier checkToken(){
         require(aave.balanceOf(msg.sender) > 0, "Invalid User");
        _;
     }

    constructor() {
     proposal_maker = msg.sender;
}

    // Functions to be executed during Creation of a Proposal
    // shall I put all my logic into constructor?
    function set_CID ( string memory  _cid ) public {
        require(msg.sender == proposal_maker,"Invalid User");
        require(nonceCID == 0, "Already done");
        proposal_CID = _cid;
        nonceCID++;
        emit ProposalCreated(msg.sender, proposal_CID);
    }

    // we store not the actual keys but hashes of those keys here
    function setKeys ( string memory _publicKey, string memory _privateKey ) public checkToken {
        require(msg.sender == proposal_maker, "Invalid User");
        require(nonceKeys == 0, "Already done");
        privateKeyHash = _privateKey;
        publicKeyHash = _publicKey;
        nonceKeys++;
    }
    
    function checkVoted() public view checkToken returns(bool) {
        return has_voted[msg.sender];
    }

    function get_hash() public view checkToken returns(string memory) {
        return proposal_CID;
    }
 
    // Update mapping when user votes
    function updateVote() public checkToken   {
    require(has_voted[msg.sender] == false, "Can't vote again" );
    has_voted[msg.sender] = true;
    emit Voted(msg.sender, block.timestamp );
    }

    function submitZKHash( uint256 zkhash ) public checkToken  {
        require(hasSubmittedZK[msg.sender] == false, "Can't submit again");
        ZKHash.push(zkhash);
        hasSubmittedZK[msg.sender] = true;
    }

    
}
