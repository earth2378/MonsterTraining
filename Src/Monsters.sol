pragma solidity ^0.4.18;

import "./Random.sol";

contract Monsters{
    //version 1.0.2
    Random random = new Random();

    struct Realm{
        address owner;
        mapping(string => Monster)realm;
        string[] index;
        string cm;
        bool valid;
    }
    struct Monster{
        bool valid;
        string Race;
        int Str;
        int Dex;
        int Int;
        int Luk;
        int Hp;
        int Mp;
    }

    mapping(address => Realm)userRealm;

    function Monsters()public{
    }

    modifier monsterValid{
        require(userRealm[msg.sender].realm[userRealm[msg.sender].cm].valid == true);
        _;
    }
    modifier nonNegative(int value){
        require(value >= 0);
        _;
    }
    modifier Owner{
        require(msg.sender == userRealm[msg.sender].owner);
        _;
    }
    modifier Valid{
        require(userRealm[msg.sender].valid == true);
        _;
    }

    function getCM()public view returns(bytes32){return stringToBytes32(userRealm[msg.sender].cm);}
    function getStat(string name)public view returns(int[6]){
        Monster storage tmp = userRealm[msg.sender].realm[name];
        return [tmp.Hp,tmp.Mp,tmp.Str,tmp.Dex,tmp.Int,tmp.Luk];
    }
    function getValid(string name)public view returns(bool){return userRealm[msg.sender].realm[name].valid;}
    function getRace(string name)public view returns(bytes32){return keccak256(userRealm[msg.sender].realm[name].Race);}
    function getName(uint i)public view returns(bytes32){return stringToBytes32(userRealm[msg.sender].index[i]);}
    function loadStat()public view returns(int[6]){return getStat(userRealm[msg.sender].cm);}

    function initRealm()public{
        Realm storage myRealm = userRealm[msg.sender];
        myRealm.owner = msg.sender;
        myRealm.valid = true;
    }

    function load(string name)public Owner Valid{
        require(userRealm[msg.sender].realm[name].valid == true);
        userRealm[msg.sender].cm = name;

    }

    function hatch(string name)public Owner Valid{
        Realm storage myMonster = userRealm[msg.sender];
        require(myMonster.realm[name].valid == false);
        myMonster.index.push(name);
        myMonster.realm[name].valid = true;
        uint randomNum = random.randomSourceStat(name);
        initRace(name,randomNum);
        initStat(name,randomNum);
        initExtraStat(name,myMonster.realm[name].Race,randomNum);
    }

    function upgradeHp (int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Hp  += value;}
    function upgradeMp (int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Mp  += value;}
    function upgradeStr(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Str += value;}
    function upgradeDex(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Dex += value;}
    function upgradeInt(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Int += value;}
    function upgradeLuk(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Luk += value;}

    function initRace(string name,uint n)private{
        userRealm[msg.sender].realm[name].Race = bytes32ToString(random.raceRandom(n));
    }
    function initStat(string name,uint n)private{
        int[6] memory status = random.statsRandom(n);
        Realm storage myMonster = userRealm[msg.sender];
        myMonster.realm[name].Hp  = status[0];
        myMonster.realm[name].Mp  = status[1];
        myMonster.realm[name].Str = status[2];
        myMonster.realm[name].Dex = status[3];
        myMonster.realm[name].Int = status[4];
        myMonster.realm[name].Luk = status[5];
    }
    function initExtraStat(string name,string race,uint n)private{
        bytes32 tmp = keccak256(race);
        Realm storage myMonster = userRealm[msg.sender];
        if(tmp == keccak256("Slime")){
            int[6] memory extraS = random.extraStatsRandomSlime(n);
            myMonster.realm[name].Hp  += extraS[0];
            myMonster.realm[name].Mp  += extraS[1];
            myMonster.realm[name].Str += extraS[2];
            myMonster.realm[name].Dex += extraS[3];
            myMonster.realm[name].Int += extraS[4];
            myMonster.realm[name].Luk += extraS[5];
        }else{
            int[2] memory extra = random.extraStatRandom(n);
            if(tmp == keccak256("Bear")){
                myMonster.realm[name].Str += extra[0];
                myMonster.realm[name].Hp  += extra[1]*10;
            }
            if(tmp == keccak256("Wolf")){
                myMonster.realm[name].Dex += extra[0];
                myMonster.realm[name].Luk += extra[1];
            }
            if(tmp == keccak256("Fairy")){
                myMonster.realm[name].Int += extra[0];
                myMonster.realm[name].Mp  += extra[1]*10;
            }
            if(tmp == keccak256("Rabbit")){
                myMonster.realm[name].Luk += extra[0];
                myMonster.realm[name].Dex += extra[1];
            }
        }
    }
    function stringToBytes32(string memory source)private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
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
