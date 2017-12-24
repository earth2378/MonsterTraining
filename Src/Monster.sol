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
        realm[name].race = random.raceRandom(name);
        initStat(name,randomNum);
        initExtraStat(name,race,randomNum);
    }

    function initStat(string name,uint n)private{
        int[6] storage status = random.statsRandom(n);
        realm[name].Hp  = status[0];
        realm[name].Mp  = status[1];
        realm[name].Str = status[2];
        realm[name].Dex = status[3];
        realm[name].Int = status[4];
        realm[name].Luk = status[5];

    }

    function initExtraStat(string name,string race,uint randomNum)private{
        bytes32 tmp = sha256(race);
        uint[2] storage extra = random.extraStatRandom();
        if(tmp == sha256("Slime")){

        }else{  
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

    function extraStatRandom(string name,string race,uint randomNum)private{
        uint n = randomNum/19%100;
        uint n2 = randomNum/86%100;
        bytes32 tmp = sha256(race);



        if(tmp == sha256("Slime")){
            realm[name].Str += (int)(randomNum/74%3)+1;
            realm[name].Dex += (int)(randomNum/44%3)+1;
            realm[name].Int += (int)(randomNum/91%3)+1;
            realm[name].Luk += (int)(randomNum/53%3)+1;
            realm[name].Hp += (extra[0]-2)*10;
            realm[name].Mp += extra[1]*10;
        }
    }
}
