pragma solidity ^0.4.18;

import "./Random.sol";

contract Monsters{
    Random random = new Random();
    string[] index;
    mapping(string => Monster)realm;
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
    string currentMonster = "";


    function Monsters(string name)public{
        hatch(name);
    }

    function getCM()public constant returns(string){return currentMonster;}
    function getStat(string name)public constant returns(int[6]){
        Monster storage tmp = realm[name];
        int[6] memory stat = [tmp.Hp,tmp.Mp,tmp.Str,tmp.Dex,tmp.Int,tmp.Luk];
        return stat;
    }
    function getValid()public constant returns(bool){return realm[currentMonster].valid;}
    function getRace()public constant returns(string){return realm[currentMonster].Race;}
    function getName(uint i)public constant returns(string){return index[i];}

    function load(string name)public{
        if(realm[name].valid == true){
            currentMonster = name;
        }
    }

    function hatch(string name)public{
        require(realm[name].valid == false);
        index.push(name);
        realm[name].valid = true;
        uint randomNum = random.randomSource(name);
        realm[name].Race = bytes32ToString(random.raceRandom(name));
        initStat(name,randomNum);
        initExtraStat(name,realm[name].Race,randomNum);
    }

    function initStat(string name,uint n)private{
        int[6] memory status = random.statsRandom(n);
        realm[name].Hp  = status[0];
        realm[name].Mp  = status[1];
        realm[name].Str = status[2];
        realm[name].Dex = status[3];
        realm[name].Int = status[4];
        realm[name].Luk = status[5];

    }

    function initExtraStat(string name,string race,uint n)private{
        bytes32 tmp = sha256(race);
        if(tmp == sha256("Slime")){
            int[6] memory extraS = random.extraStatsRandomSlime(n);
            realm[name].Hp  = extraS[0];
            realm[name].Mp  = extraS[1];
            realm[name].Str = extraS[2];
            realm[name].Dex = extraS[3];
            realm[name].Int = extraS[4];
            realm[name].Luk = extraS[5];
        }else{
            int[2] memory extra = random.extraStatRandom(n);
            if(tmp == sha256("Golem")){
                realm[name].Str += extra[0];
                realm[name].Hp  += extra[1]*10;
            }
            if(tmp == sha256("Wolf")){
                realm[name].Dex += extra[0];
                realm[name].Luk += extra[1];
            }
            if(tmp == sha256("Fairy")){
                realm[name].Int += extra[0];
                realm[name].Mp  += extra[1]*10;
            }
            if(tmp == sha256("Rabbit")){
                realm[name].Luk += extra[0];
                realm[name].Dex += extra[1];
            }
        }
    }
    
    
    function bytes32ToString(bytes32 x)public pure returns (string) {
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
