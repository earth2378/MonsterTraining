pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monsters.sol";

contract MonsterTraining{

    Mine mine = new Mine();
    Inventory inventory;
    Monsters monsters;
    mapping(address => bytes32)passwordStorage;
    address GM;
    mapping(address => bytes32)selectedMonster;
    mapping(address => string[])userIndex;
    function MonsterTraining(address i, address m)public{
        GM = msg.sender;
        inventory = Inventory(i);
        monsters = Monsters(m);
    }
    function userMValid()public view returns(bool){return monsters.userValid();}
    function getBalance()public view returns(int){return inventory.getZil();}
    function mySelectedMonster()public view returns(bytes32){return selectedMonster[msg.sender];}
    function myBag()public view returns(int[7]){return inventory.getBag();}
    function myTicket()public view returns(int){return inventory.getTicket();}
    function loadStat()public view returns(int[6]){return monsters.loadStat();}
    function getMe()public view returns(address){return msg.sender;}
    function checkStat(string name)public view returns(int[6]){return monsters.getStat(name);}
    function monsterExist(string name)public view returns(bool){return monsters.getValid(name);}
    function getMyMonster(uint i)public view returns(string){return userIndex[msg.sender][i];}

    function register(string password)public{
        require(passwordStorage[msg.sender] == bytes32(0));
        passwordStorage[msg.sender] = keccak256(msg.sender,password);
        inventory.initBag();
        monsters.initRealm();
    }

    function topUp() public payable{
        uint tmp = msg.value/1000000000000000000;
        inventory.topUp(tmp);
    }

    function hatchMonster(string name)public{
        inventory.useEgg();
        monsters.hatch(name);
        userIndex[msg.sender].push(name);
    }

    function loadMonster(string name)public{
        monsters.load(name);
        selectedMonster[msg.sender] = monsters.getCM();
    }

    function buyTicket(int n)public{
        inventory.buyTicket(n);
    }
    function buyEgg(int n)public{
        inventory.buyEgg(n);
    }

    function mining(string word)public{
        inventory.useTicket();
        bytes32 classTmp;
        int amountTmp;
        bytes32 tmp = keccak256(word);
        (classTmp,amountTmp) = mine.mine(tmp);
        inventory.receiveGem(classTmp,amountTmp);
    }

    function useGem(string class, int amount)public{
        bytes32 classTmp = keccak256(class);
        inventory.useGem(classTmp,amount);
        if(classTmp == keccak256("Hp")){
            monsters.upgradeHp(amount*10);
        }else if(classTmp == keccak256("Mp")){
            monsters.upgradeMp(amount*10);
        }else if(classTmp == keccak256("Str")){
            monsters.upgradeStr(amount);
        }else if(classTmp == keccak256("Dex")){
            monsters.upgradeDex(amount);
        }else if(classTmp == keccak256("Int")){
            monsters.upgradeInt(amount);
        }else if(classTmp == keccak256("Luk")){
            monsters.upgradeLuk(amount);
        }else if(classTmp == keccak256("Crude")){
            //for exchange (Not implement yet)
        }
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
