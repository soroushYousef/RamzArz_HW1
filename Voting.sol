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
        bool is_voted;
        bool is_registered;

    }

    constructor(string memory _title,uint  _maximun_number_of_voters,uint  _date_of_start,uint  _date_of_end,string[] memory _candidates){
        Abbas = msg.sender;
        // candidates = new string[](number_of_candidates);
        candidates = new string[];
        title = _title;
        maximun_number_of_voters = _maximun_number_of_voters;
        date_of_start = _date_of_start;
        date_of_end = _date_of_end;
        candidates = _candidates;
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
            if(voters[_voters[i]].is_registerd){
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
             voters[_voters[i]].is_registerd = true;
        }

    }

    //baray ray dadan
    function vote (string memory _elected) public {
        Voter voter = voters[msg.sender];
    }

    //elam natije
    function result () public view returns(string memory){
        //barresi etmam voting
        //require(){
            // , "Voting have'nt been closed yet"
        // };
        string memory result_to_publish = "";
        bool unique_winner = false;
        uint max_votes = 0;
        uint winner = -1;
        for(uint8 i =0 ; i < votes.length;i++){
             if(votes[i] > max_votes){
                 max_votes = votes[i];
                 unique_winner = false;
                 winner = i;
             }else if(votes[i] == max_votes){
                 unique_winner = true;
             }
        }
        if(unique_winner){
            result_to_publish = candidates[winner];
        }else{
            result_to_publish = "NO_WINNER";
        }
        return result_to_publish;
    }
    

    

}