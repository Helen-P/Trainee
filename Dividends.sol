pragma solidity ^0.4.26;

contract TokenDiv {

    string public tokenSymbol;
    string public tokenName;
    uint256 public decimals = 18; 
    uint256 public totalTokens;
    uint256 public totalSupply;
    uint256 public count;
    uint256 public eth;
    address public itsHolder;
    
    //-------------------------- All Mappings ------------------------//   
    
    mapping (address => uint256) public balanceOf; 
    mapping (address => mapping (address => uint256)) public allowed;

    mapping (address => uint256) public balanceOfNew;
    address[] newBalanceArray;
    
    mapping (uint256 => address) public holders;
    address[] public allHolders; 

    //--------------------------- Input Data -------------------------//
    
    constructor () public {
        tokenSymbol = "DiV";
        tokenName = "Dividends";
        totalSupply = (10**2)**decimals;
        // getHolders();
    }
    
    //---------------- standard functions of ERC20 -------------------//
    
    function transfer(address _to, uint256 _value) public {
        assert(balanceOf[msg.sender] > _value || _value >= 0);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function transferFrom(address _from, address _to, uint256 _value)public {
        assert(balanceOf[_from] > _value || _value > 0);
        assert(allowed[_from][msg.sender] > _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowed[_from][msg.sender] -= _value;
    }

    function approve(address _spender, uint256 _value) public {
        allowed[msg.sender][_spender] = _value;
    }
    
    function allowance(address _owner, address _spender) public constant returns  (uint256 remaining) {
        return allowed[_owner][_spender];
    }  

    //------------------------ main functions ------------------------//

    
    // IterableMapping.itmap data;
    
    function addHolder(address _holder)public returns(address){
        itsHolder = _holder;
        allHolders.push(itsHolder);
        count = allHolders.length;
        holders[count] = itsHolder;
        balanceOf[itsHolder] = itsHolder.balance; //// here bug
        itsHolder = holders[count];
        return itsHolder;
    }
    
    function receive () public payable returns(uint256){
        require(eth<=0, "Ether is already credited");
        eth = address(this).balance;  
        return eth;
    }
        
    uint256 public balanceNow;
    uint256 public reward;
    
    function divideUpReward(address _holder) public payable{
        require(eth>=0 , "No ether for reward");
        for(uint256 i = 0; i<allHolders.length; i++){
            require(balanceOfNew[holders[i]]==0, "This holder has already received a reward");
            balanceNow = balanceOf[_holder];
            reward = (balanceOf[_holder])/eth;
            balanceOfNew[_holder] = (balanceOf[_holder])+reward;
            totalSupply -= reward;
            // eth -= reward;
            newBalanceArray.push(_holder);
        }
    }
}


