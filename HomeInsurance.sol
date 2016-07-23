contract HomeInsurance{

    uint THRESHOLD = 5;
    uint OPEN_MINUTES = 5;
    uint PAYOUT = 1;
    uint costToJoinInEther = 1;
    mapping (address => bool) members;
    uint total_amount;
    Claim current_claim;

    struct member{
        address member_address;
    }

    struct Vote{
        bool approved;
        address voter;
    }

    struct Claim{
        address claimant;
        string description;
        Vote[] votes;
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
            Claim c;
            c.claimant = msg_sender;
            c.description = desc;
            c.processed = false;
            current_claim = c;
        }
    }

    function castVote (bool approve){
        address msg_sender = msg.sender;
        if(members[msg_sender] == true){
            Vote v;
            v.approved = approve;
            v.voter = msg_sender;
            current_claim.votes.push(v);
        } else{
            return;
        }
    }

    function yesCount () constant returns (uint){
        uint count = 0;
        for(uint i = 0;i < current_claim.votes.length; i++) {
            if(current_claim.votes[i].approved == true){
                count++;
            }
        }
        return count;
    }
}
