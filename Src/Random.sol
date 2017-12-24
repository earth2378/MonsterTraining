pragma solidity ^0.4.18;

contract Random{
    string race;
    uint[2] extra;
    int[6] status;
    function randomSource(string name)public view returns(uint){
        uint random = uint256(keccak256(name,block.timestamp,msg.sender));
        return random;
    }

    function raceRandom(string name)public returns(string){
        uint n = randomSource(name);
        if(0 <= n || n < 100){
            if(n<23){
                race = "Golem";
            }else if(n<46){
                race = "Wolf";
            }else if(n<69){
                race = "Fairy";
            }else if(n<92){
                race = "Rabbit";
            }else if(n<100){
                race = "Slime";
            }
            return race;
        }
    }

    function statRandom(uint n)public pure returns(int){
        int stat;
        if(0 <= n || n < 100){
            if(n<9){
                stat = 3;
            }else if(n<24){
                stat = 4;
            }else if(n<51){
                stat = 5;
            }else if(n<76){
                stat = 6;
            }else if(n<92){
                stat = 7;
            }else if(n<100){
                stat = 8;
            }
            return stat;
        }
    }

    function statsRandom(uint n)public returns(int[6]){
        status[0] = (statRandom(n/48%100)+7)*10;
        status[1] = (statRandom(n/79%100)+7)*10;
        status[2] = statRandom(n/31%100);
        status[3] = statRandom(n/23%100);
        status[4] = statRandom(n/66%100);
        status[5] = statRandom(n/15%100);
        return status;
    }
    
    function statsRandomSlime(uint n)public returns(int[6]){
        
    }

    function extraStatRandom(uint n)public returns(uint[2]){
        uint primaryRandom = n/19%100;
        uint secondary = n/86%100;
        if(0 <= primaryRandom || primaryRandom < 100){
            if(primaryRandom<67){extra[0] = 3;}
            else{extra[0] = 4;}
        }
        if(0 <= secondary || secondary < 100){
            if(secondary<67){extra[1] = 1;}
            else{extra[1] = 2;}
        }
        return extra;
    }
}