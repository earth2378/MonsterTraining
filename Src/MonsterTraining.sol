pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monsters.sol";

contract MonsterTraining{
    
    
    //mapping(address => Monsters)realm;
    //mapping(address => Inventory)inventory;
    mapping(address => bytes32)passwordStorage;
    address GM;
    mapping(address => bytes32)selectedMonster;

    function MonsterTraining()public{
        GM = msg.sender;
    }

    function getBalance()public view returns(int){
        return inventory[msg.sender].getZil();
    }
    function mySelectedMonster()public view returns(bytes32){
        return selectedMonster[msg.sender];
    }
    function myBag()public view returns(int[7]){
        return inventory[msg.sender].getBag();
    }
    function myTicket()public view returns(int){
        return inventory[msg.sender].getTicket();
    }
    function get()public view returns(int[6]){
        return realm[msg.sender].loadStat();
    }

    function hashedPass()public view returns(bytes32){
        return passwordStorage[msg.sender];
    }

    function register(string password)public{
        require(passwordStorage[msg.sender] == bytes32(0));
        passwordStorage[msg.sender] = keccak256(msg.sender,password);
        realm[msg.sender] = new Monsters();
        inventory[msg.sender] = new Inventory();
    }

    function topUp() public payable{
        uint tmp = msg.value/1000000000000000000;
        inventory[msg.sender].topUp(tmp);
    }

    function hatchMonster(string name)public{
        inventory[msg.sender].useTicket();
        realm[msg.sender].hatch(name);
    }
    
    function loadMonster(string name)public{
        realm[msg.sender].load(name);
        selectedMonster[msg.sender] = realm[msg.sender].getCM();
    }
    
    function buyTicket(int n)public{
        inventory[msg.sender].buyTicket(n);
    }
    
    
    
    function bytes32ToString(bytes32 x)private pure returns(string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}
