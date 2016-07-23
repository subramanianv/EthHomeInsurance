contract HomeInsurance{

    uint VOTING_THRESHOLD = 3;
    uint OPEN_MINUTES = 5;
    uint PAYOUT = 1;
    uint costToJoinInEther = 1;
    mapping (address => bool) members;
    uint total_amount;
    Claim current_claim;
    Claim c;


    struct member{
        address member_address;
    }

    // struct Vote{
    //     bool approved;
    //     address voter;
    // }

    struct Claim{
        address claimant;
        string description;
        mapping (address => bool) voters;
        uint yesVotes;
        uint noVotes;
        uint totalVotes;
        bool processed;
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
    function getClaim() constant returns(string){
        return current_claim.description;

    }


    function isMember(address input) constant returns(bool){
        if(members[input] == true){
            return true;
        } else{
            return false;
        }
    }

    function amIMember() constant returns (bool){
        address msg_sender = msg.sender;
        if(members[msg_sender] == true){
            return true;
        } else{
            return false;
        }
    }

    function makeClaim (string desc){
        address msg_sender = msg.sender;
        if(members[msg_sender]  != true){
            return;
        }else {
            c.claimant = msg_sender;
            c.description = desc;
            c.processed = false;
            current_claim = c;
        }
    }
    function resolveVotesAndPayout(){
       if(current_claim.totalVotes >= VOTING_THRESHOLD  && current_claim.yesVotes >= current_claim.noVotes) {
            current_claim.claimant.send(PAYOUT);
        }


    }


    function castVote (bool approve){
        address msg_sender = msg.sender;
        if(current_claim.claimant == msg_sender) {
            return;
        }
        if(current_claim.voters[msg_sender] == true) {
            return;
        }
        current_claim.voters[msg_sender] = true;
        if(members[msg_sender] == true){
            if(approve == true) {
                current_claim.yesVotes +=1;
            }else{
                current_claim.noVotes +=1;
            }
            current_claim.totalVotes +=1;
        } else{
            return;
        }
        resolveVotesAndPayout();

    }

    function yesCount () constant returns (uint){
        uint count = 0;
        return current_claim.yesVotes;
    }

}
