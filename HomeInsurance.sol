contract HomeInsurance{

    uint VOTING_THRESHOLD = 3;
    uint OPEN_MINUTES = 5;
    uint PAYOUT = 1;
    uint costToJoinInEther = 1;
    mapping (address => bool) members;
    mapping (uint => Claim) claims;
    uint claimId = 0;
    uint total_amount;

    struct member {
        address member_address;
        uint premium;
        uint lastPremium;
    }
    struct Claim {
        address claimant;
        string description;
        mapping (address => bool) voters;
        uint yesVotes;
        uint noVotes;
        uint totalVotes;
        bool processed;
        uint payout;
        uint claimId;
    }

    function HomeInsurance () {

    }

    function (){
        address new_member = msg.sender;
        uint msg_value = msg.value;
        if(msg_value < costToJoinInEther){
            return;
        }
        else{
            if(members[new_member] == true){
                return;
            }
            members[new_member] = true;
            total_amount += msg_value;
        }
    }

    function isMember(address input) constant returns(bool){
        if(members[input] == true){
            return true;
        } else{
            return false;
        }
    }
    function getDescription(uint _claimId) constant returns(string) {
         return claims[_claimId].description;
    }

    function makeClaim (uint claimAmount, string desc){
        address msg_sender = msg.sender;
        if(members[msg_sender]  != true){
            return;
        }else {
            uint c_id= ++claimId;
            Claim c = claims[c_id];
            c.claimId = c_id;
            c.claimant = msg_sender;
            c.description = desc;
            c.processed = false;
            c.payout = claimAmount;
            c.yesVotes = 0;
            c.noVotes = 0;
            c.totalVotes = 0;
        }
    }

    function currentClaimId() constant returns (uint) {
      return claimId;
    }
    function castVote (uint _claimId, bool approve) {
        address msg_sender = msg.sender;

        if(claims[_claimId].processed == true) {
          return;
        }
        if(claims[_claimId].claimant == msg_sender) {
            return;
        }
        if(claims[_claimId].voters[msg_sender] == true) {
            return;
        }
        claims[_claimId].voters[msg_sender] = true;
        if(members[msg_sender] == true){
            if(approve == true) {
                claims[_claimId].yesVotes +=1;
            }else{
                claims[_claimId].noVotes +=1;
            }
            claims[_claimId].totalVotes +=1;
        } else{
            return;
        }

        if(claims[_claimId].totalVotes >= VOTING_THRESHOLD  &&
          claims[_claimId].yesVotes >= claims[_claimId].noVotes)
           {
            claims[_claimId].processed = true;
            uint _p = claims[_claimId].payout * 1000000000000000000;
            claims[_claimId].claimant.send(_p);
        }
    }

    function yesCount (uint _claimId) constant returns (uint){
        return claims[_claimId].yesVotes;
    }

    function noCounts (uint _claimId) constant returns (uint) {
      return claims[_claimId].noVotes;
    }

}
