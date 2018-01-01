pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monsters.sol";

contract MonsterTraining{
    
    
    Inventory inventory;
    Monsters monsters;
    mapping(address => bytes32)passwordStorage;
    address GM;
    mapping(address => bytes32)selectedMonster;

    function MonsterTraining(address i, address m)public{
        GM = msg.sender;
        inventory = Inventory(i);
        monsters = Monsters(m);
    }

    function getBalance()public view returns(int){
        return inventory.getZil();
    }
    function mySelectedMonster()public view returns(bytes32){
        return selectedMonster[msg.sender];
    }
    function myBag()public view returns(int[7]){
        return inventory.getBag();
    }
    function myTicket()public view returns(int){
        return inventory.getTicket();
    }
    function get()public view returns(int[6]){
        return monsters.loadStat();
    }

    function hashedPass()public view returns(bytes32){
        return passwordStorage[msg.sender];
    }

    function register(string password)public{
        require(passwordStorage[msg.sender] == bytes32(0));
        passwordStorage[msg.sender] = keccak256(msg.sender,password);
        inventory.initBag();
        monsters.initRealm;
    }

    function topUp() public payable{
        uint tmp = msg.value/1000000000000000000;
        inventory.topUp(tmp);
    }

    function hatchMonster(string name)public{
        inventory.useTicket();
        monsters.hatch(name);
    }
    
    function loadMonster(string name)public{
        monsters.load(name);
        selectedMonster[msg.sender] = monsters.getCM();
    }
    
    function buyTicket(int n)public{
        inventory.buyTicket(n);
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
