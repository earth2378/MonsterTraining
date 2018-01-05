pragma solidity ^0.4.18;

import "./Random.sol";

contract Mine{
    //version 1.0.0
    Random random = new Random();
    struct product{
        bytes32 class;
        int amount;
    }
    product reward;

    function Mine()public{
        clearTmp();
    }

    function getClass()public view returns(string){return bytes32ToString(reward.class);}
    function getAmount()public view returns(int){return reward.amount;}
    function getReward()public view returns(bytes32, int){return (reward.class,reward.amount);}

    function mine(bytes32 word)public returns(bytes32, int){
        clearTmp();
        uint randomNum = random.randomSourceMine(word);
        uint roll = randomNum%16;
        randomNum = randomNum%20;
        reward.class = minedClass(roll);
        reward.amount = minedAmount(reward.class,randomNum);
        return (reward.class,reward.amount);
    }


    function minedClass(uint n)private pure returns(bytes32){
        bytes32 class;
        if(n == 0){ class = keccak256("Hp");}
        else if(n == 1){ class = keccak256("Mp");}
        else if(n == 2){ class = keccak256("Str");}
        else if(n == 3){ class = keccak256("Dex");}
        else if(n == 4){ class = keccak256("Int");}
        else if(n == 5){ class = keccak256("Luk");}
        else if(n>=6 && n<10){ class = keccak256("Crude");}
        else if(n>=10 && n<14){ class = keccak256("Zil");}
        else{ class = keccak256("Empty");}
        return class;
    }

    function minedAmount(bytes32 class,uint n)private pure returns(int){
        int tmp = (int)(n);
        if(class == keccak256("Empty")){return 0;}
        else if(class == keccak256("Zil")){return 1000 + (tmp*10);}
        else if(class == keccak256("Crude")){
            if(tmp <5)return 1;
            else if(tmp <15)return 2;
            else return 3;
        }
        else{
            if(tmp <13)return 1;
            else if(tmp <18)return 2;
            else return 3;
        }
    }

    function clearTmp()private{
        reward.class = keccak256("Undified");
        reward.amount = 0;
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
