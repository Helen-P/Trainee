pragma solidity ^0.5.16;

import "./AddOwners.sol";
// import "./Migrations";

contract ERC20 is Owned {

    uint8 public decimals = 18;
    uint256 public totalSupply;
    string public tokenName = 'ERC20';
    string public tokenSymbol = "OwN";
    
    
    mapping(address=>mapping(address=>uint8)) candidate;
    mapping(address => uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance; 
    
    event Transfer( address indexed from, address indexed to, uint256 value);
    event Approval( address indexed _owner, address indexed _spender, uint256 value);
    
    constructor (uint256 initialSupply) public{
        totalSupply = initialSupply*10**uint256(decimals);
        balanceOf[owner] = totalSupply;
    }
    
    
    function _transfer(address _from, address _to, uint _value) internal{
        require(balanceOf[_from]>=_value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _value;
        balanceOf[_to]+=_value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from]+balanceOf[_to]==previousBalances);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        _transfer(owner, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= allowance[_from][owner]);
        allowance[_from][owner] -= _value; 
        _transfer(_from, _to, _value);
        return true;
    }

    function approve (address _spender, uint256 _value) public returns(bool success){
        allowance[owner][_spender] = _value;
        emit Approval(owner, _spender, _value);
        return true;
    }

}
