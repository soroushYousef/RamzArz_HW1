pragma solidity ^0.8.0;

contract Elections {
    uint number_of_voters = 0;
    uint maximun_number_of_voters;
    // uint number_of_candidates = 100;
    uint date_of_start;
    uint date_of_end;
    uint number_of_registered;
    string title;
    string[] candidates;
    mapping (address => Voter) voters;
    mapping (string => uint) votes; // candidates must be added to this map too
    address public Abbas;
    
    struct Voter {
        string elected;
        // bool is_voted;
        bool is_registered;
        uint available_votes;
    }

    constructor(string memory _title,uint  _maximun_number_of_voters,uint  _date_of_start,uint  _date_of_end,string[] memory _candidates){
        Abbas = msg.sender;
        // candidates = new string[](number_of_candidates);
        title = _title;
        maximun_number_of_voters = _maximun_number_of_voters;
        date_of_start = _date_of_start;
        date_of_end = _date_of_end;
        candidates = _candidates;
        //votes map initialized
        // for (uint8 i = 0 ; i < _candidates.length;i++){
        //     votes[_candidates[i]] = 0;
        // }
    }


    function time_check() public view returns(bool){
        return block.timestamp >= date_of_end;
    }


    function register_voters (address[] memory _voters) public {
        // check kardan in ke admin bashe
        require (
            msg.sender == Abbas,
            "you are not Abbas"
        );
        //miad tedad va hamintoor in ke sab nami tekrari nabashe ro check mikone
        bool is_registeration_valid = false;
        for(uint8 i = 0 ;i < _voters.length;i++){
            if(voters[_voters[i]].is_registered){
                is_registeration_valid = true;
            }
            else {
                number_of_registered++;
            }
        }
        require (
            !is_registeration_valid,
            "duplicate name is not vlid"
        );
        require (                                                           
            number_of_registered <= maximun_number_of_voters,
            "too many voters"
        );

        //sabt nam kardan afrad jadid
        for(uint8 i =0 ; i < _voters.length;i++){
             voters[_voters[i]].is_registered = true;
             voters[_voters[i]].available_votes = 1;
        }

    }
    function move_vote_right(address _target_voter) public{
        Voter memory voter = voters[msg.sender];
        Voter memory target = voters[_target_voter];
        require (
            voter.is_registered,
            "you don't have any voting right"
        );
        require(
            voter.available_votes > 0,
            "your available votes are 0"
        );
        require(
            target.is_registered,
            "target is not registered"
        );
        target.available_votes += voter.available_votes;
        voter.available_votes = 0;
    }
    //baray ray dadan
    function vote (string memory _elected) public {
        Voter storage voter = voters[msg.sender];
        /*
            check kardan in ke ye bar ray bede 
        */
         require(
            voter.available_votes > 0,
            "your available votes are 0"
        );
        /*
            check kardan in ke sabt nam shode bashe 
        */
        require(
            !voter.is_registered,
            "You are not registerd" 
        );
        /*
            check kardan in ke zaman doroste 
        */
        require(
            time_check(),
            "time is over"
        );
        
        votes[_elected]++;
        voter.elected = _elected;
        voter.available_votes--;

    }


    function set_date_of_end (uint _date_of_end) public {
        require(
            msg.sender == Abbas, "You are not Abbas"
        );
        require(
            _date_of_end > date_of_end, "This function should be extend voting not shorten it"
        );
        date_of_end = _date_of_end;
    }

    //elam natije
    function result () public view returns(string memory){
        //barresi etmam voting
        require(
           time_check() , "Voting have'nt been closed yet"
        );
        string memory result_to_publish = "";
        bool unique_winner = false;
        uint max_votes = 0;
        uint winner = 0;
        uint total_votes = 0;
        for(uint i =0 ; i < candidates.length;i++){
             if(votes[candidates[i]] > max_votes){
                 max_votes = votes[candidates[i]];
                 unique_winner = false;
                 winner = i;
             }else if(votes[candidates[i]] == max_votes){
                 unique_winner = true;
             }
             total_votes += votes[candidates[i]];
        }
        require(
            (total_votes / number_of_registered)*100 > 50, 
            "This election is cancelled due to lack of votes recieved."
        );
        if(unique_winner){
            result_to_publish = candidates[winner];
        }else{
            result_to_publish = "NO_WINNER";
        }
        return result_to_publish;
    }
    

    

}