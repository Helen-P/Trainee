pragma solidity ^0.5.16;

contract Owned {

    address public owner ;
    address public secondOwner;
    address public candidate;
    uint256 public countOwner=0; //количество элементов в масив (длина)
    uint256 public countVotes = 0;
    uint256 public count = 0;
    
    constructor(address _secondowner) public {
        owner = msg.sender;
        secondOwner = _secondowner;
    }
    
    //Список владельцева
    //Хранить параллельно значения массива и мепинга 
    address[] public ownersList;
    mapping(address=>uint) ownersID;
    
    //for votes
    // address[] public 
    mapping(address => mapping (address => bool)) votingMap; //
    mapping(address => uint256) countVotesTrue;
    
    
    event Voit( address indexed candidate, address indexed owner, bool vote);

    // struct Voting{
    //     address ownerAddress;
    //     bool vote;
    // }
    
    modifier onlyCoincidences{
        require(owner != secondOwner && secondOwner!=owner, "address owner == secondOwner");
        require(owner != candidate && candidate !=owner, "address owner == candidate");
        require(secondOwner != candidate && candidate !=secondOwner, "secondOwner == candidate");
        _;
    }
    
    modifier onlyOwner  {
        require(owner == msg.sender, "Owner!=msg.sender");
        _;
    }
    
    modifier onlySecondOwner {
        require(secondOwner!=owner, 'This is the address of the first owner');
        require(secondOwner!=candidate, 'This is the address of the candidate');
        _;
    }
    
    modifier onlyOwners {
        require(ownersID[msg.sender] != 0);
        _; 
    }
    
    function firstOwners()public onlyOwner onlySecondOwner onlyCoincidences {
        address _secondowner = secondOwner;
        ownersList.push(msg.sender);
        ownersList.push(_secondowner);
        countOwner=ownersList.length;
    }
    
    // function addOwner(address _newAddress) public {
        // require((countVotesTrue[candidate]*2)>=countOwner || countVotesTrue[candidate]==0 , "Voted against");
        // // require(candidate==ownersList[count]);
        // ownersList.push(candidate);
        // ownersID[candidate]=ownersList.length;
        // countOwner++;
        // delete countVotesTrue[_newAddress];
        // // delete votingMap[candidate][owner]; не могу перебрать всех owners;
    // }
    
    function voing(address _newAddress, bool _vote) public{ 
        candidate = _newAddress;
        if(count>=countOwner) count = 0;
        address _owner = ownersList[count];
        countVotes++;
        // votingMap[candidate] = Voting({ownerAddress:_owner, vote: _vote});
        votingMap[candidate][_owner]=_vote;
        if(_vote==true){
            countVotesTrue[candidate]++;
        }
        if(countVotes==countOwner) {
            require((countVotesTrue[candidate]*2)>=countOwner || countVotesTrue[candidate]==0 , "Voted against");
            ownersList.push(candidate);
            ownersID[candidate]=ownersList.length;
            countOwner++;
            delete countVotesTrue[_newAddress];
        }
        count++;
    }

}
