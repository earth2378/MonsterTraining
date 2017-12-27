pragma solidity ^0.4.18;

contract Random{
    bytes32 race;
    int[2] extra;
    int[6] status;
    int[6] slimeExtra;

    function randomSourceStat(string name)public view returns(uint){
        uint random = uint256(keccak256(name,block.timestamp,msg.sender));
        return random;
    }

    function raceRandom(uint n)public returns(bytes32){
        n = n/99%100;
        if(0 <= n || n < 100){
            if(n<23){
                race = "Bear";
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

    function statRandom(uint n)private pure returns(int){
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

    function extraStatRandomSlime(uint n)private pure returns(int){
        int stat;
        if(0 <= n || n < 100){
            if(n<17){
                stat = 3;
            }else if(n<100){
                stat = 2;
            }
            return stat;
        }
    }

    function extraStatsRandomSlime(uint n)public returns(int[6]){
        slimeExtra[0] =(extraStatRandomSlime(n/74)-1)*10;
        slimeExtra[1] =(extraStatRandomSlime(n/44)-1)*10;
        slimeExtra[2] = extraStatRandomSlime(n/91);
        slimeExtra[3] = extraStatRandomSlime(n/53);
        slimeExtra[4] = extraStatRandomSlime(n/29);
        slimeExtra[5] = extraStatRandomSlime(n/17);
        return slimeExtra;
    }

    function extraStatRandom(uint n)public returns(int[2]){
        uint primary = n/19%100;
        uint secondary = n/86%100;
        if(0 <= primary || primary < 100){
            if(primary<67){extra[0] = 3;}
            else{extra[0] = 4;}
        }
        if(0 <= secondary || secondary < 100){
            if(secondary<67){extra[1] = 1;}
            else{extra[1] = 2;}
        }
        return extra;
    }
    
    function randomSourceMine(bytes32 word)public view returns(uint){
        uint random = uint256(keccak256(word,block.timestamp,msg.sender));
        return random;
    }
}
