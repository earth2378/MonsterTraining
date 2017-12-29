pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monsters.sol";

contract MonsterTraining{
    mapping(address => Monsters)realm;
    mapping(address => Inventory)inventory;
    mapping(address => bytes32)passwordStorage;
    address GM;
    
    function MonsterTraining(string password)public{
        GM = msg.sender;
        register(password);
    }
    
    function getBalance()public view returns(int){
        inventory[msg.sender].getZil();
    }
    
    function a()public view returns(bytes32){
        return passwordStorage[msg.sender];
    }
    
    function register(string password)public{
        require(passwordStorage[msg.sender] == bytes32(0));
        passwordStorage[msg.sender] = keccak256(msg.sender,password);
        realm[msg.sender] = new Monsters();
        inventory[msg.sender] = new Inventory();
    }
    
    function topUp() public payable{
        inventory[msg.sender].topUp();
    }
}