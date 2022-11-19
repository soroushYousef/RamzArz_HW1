pragma solidity ^0.8.0;

contract Elections {
    uint number_of_voters = 0;
    uint maximun_number_of_voters;
    // uint number_of_candidates = 100;
    uint date_of_start;
    uint date_of_end;
    uint number_of_registerd;
    string title;
    string[] candidates;
    mapping (address => Voter) voters;
    address public Abbas;
    
    struct Voter {
        string elected;
        bool is_voted;
        bool is_registerd;

    }

    constructor(string memory _title,uint memory _maximun_number_of_voters,uint memory date_of_start,uint memory _date_of_end,string[] _candidates){
        Abbas = msg.sender;
        candidates = new string[](number_of_candidates);
        title = _title;
        maximun_number_of_voters = _maximun_number_of_voters;
        date_of_start = _date_of_start;
        date_of_end = _date_of_end;
        candidates = _candidates;
    }

    function register_voters (address[] _voters) public {
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
                number_of_registerd++;
            }
        }
        require (
            !is_registeration_valid,
            "duplicate name is not vlid"
        );
        require (                                                           
            number_of_registerd <= maximun_number_of_voters,
            "too many voters"
        );

        //sabt nam kardan afrad jadid
        for(uint8 i =0 ; i < _voters.length;i++){
             voters[_voters[i]].is_registerd = true;
        }

    }

    //baray ray dadan
    function vote (string _elected) public {
        Voter voter = voters[msg.sender];
    }

    

}