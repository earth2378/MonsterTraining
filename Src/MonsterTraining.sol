pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monsters.sol";

contract MonsterTraining{

    Mine mine = new Mine();
    Inventory inventory;
    Monsters monsters;
    struct User{
        string name;
        bytes32 password;
    }
    mapping(address => User)userData;
    address GM;
    mapping(address => bytes32)selectedMonster;
    mapping(address => string[])userIndex;

    event Mined(string User, string Class, int Amount);
    event Hatch(string User, string Name, string Race, int Hp ,int Mp ,int Str ,int Dex ,int Int ,int Luk);

    function MonsterTraining(address i, address m)public{
        GM = msg.sender;
        inventory = Inventory(i);
        monsters = Monsters(m);
    }
    function myData()public view returns(string,bytes32){return (userData[msg.sender].name,userData[msg.sender].password);}
    function userMValid()public view returns(bool){return monsters.userValid();}
    function getBalance()public view returns(int){return inventory.getZil();}
    function mySelectedMonster()public view returns(bytes32){return selectedMonster[msg.sender];}
    function myBag()public view returns(int[7]){return inventory.getBag();}
    function myTicket()public view returns(int){return inventory.getTicket();}
    function myEgg()public view returns(int){return inventory.getEgg();}
    function loadStat()public view returns(string,int[6]){return (getRace(),monsters.loadStat());}
    function getMe()public view returns(address){return msg.sender;}
    function checkStat(string name)public view returns(int[6]){return monsters.getStat(name);}
    function checkRace(string name)public view returns(string){return bytes32ToRace(monsters.getRace(name));}
    function monsterExist(string name)public view returns(bool){return monsters.getValid(name);}
    function getMyMonster(uint i)public view returns(string){return userIndex[msg.sender][i];}
    function getRace()public view returns(string){
        bytes32 tmp = monsters.getRaceB();
        return bytes32ToRace(tmp);
    }

    function collect(uint value)public{
        require(msg.sender == GM);
        value*=1000000000000000000;
        require(value >= this.balance);
        GM.transfer(value);
    }

    function register(string name,string password)public{
        require(userData[msg.sender].password == bytes32(0));
        userData[msg.sender] = User(name,keccak256(msg.sender,name,password));
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
        int[6] memory statTmp = checkStat(name);
        string memory raceTmp = checkRace(name);
        Hatch(userData[msg.sender].name,name,raceTmp, statTmp[0], statTmp[1], statTmp[2], statTmp[3], statTmp[4], statTmp[5]);
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
        Mined(userData[msg.sender].name,bytes32ToClass(classTmp),amountTmp);
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
    
    function bytes32ToRace(bytes32 x)private pure returns(string){
        if(x == keccak256("Golem"))return "Golem";
        else if(x == keccak256("Wolf"))return "Wolf";
        else if(x == keccak256("Fairy"))return "Fairy";
        else if(x == keccak256("Rabbit"))return "Rabbit";
        else if(x == keccak256("Slime"))return "Slime";
    }
    
    function bytes32ToClass(bytes32 x)private pure returns(string){
        if(x == keccak256("Hp"))return "Hp";
        else if(x == keccak256("Mp"))return "Mp";
        else if(x == keccak256("Str"))return "Str";
        else if(x == keccak256("Dex"))return "Dex";
        else if(x == keccak256("Int"))return "Int";
        else if(x == keccak256("Luk"))return "Luk";
        else if(x == keccak256("Crude"))return "Crude";
        else if(x == keccak256("Zil"))return "Zil";
        else if(x == keccak256("Empty"))return "Empty";
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
