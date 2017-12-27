pragma solidity ^0.4.18;

import "./Random.sol";

contract Mine{
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

    function mine(bytes32 word)public{
        clearTmp();
        uint randomNum = random.randomSourceMine(word);
        uint roll = randomNum%16;
        randomNum = randomNum%20;
        reward.class = minedClass(roll);
        reward.amount = minedAmount(reward.class,randomNum);
    }


    function minedClass(uint n)private pure returns(bytes32){
        bytes32 class;
        if(n == 0){ class = bytes32("Hp");}
        else if(n == 1){ class = bytes32("Mp");}
        else if(n == 2){ class = bytes32("Str");}
        else if(n == 3){ class = bytes32("Dex");}
        else if(n == 4){ class = bytes32("Int");}
        else if(n == 5){ class = bytes32("Luk");}
        else if(n>=6 && n<10){ class = bytes32("Crude");}
        else if(n>=10 && n<14){ class = bytes32("Zil");}
        else{ class = bytes32("Empty");}
        return class;
    }

    function minedAmount(bytes32 class,uint n)private pure returns(int){
        int tmp = (int)(n);
        if(class == bytes32("Empty")){return 0;}
        else if(class == bytes32("Zil")){return 1000 + (tmp*10);}
        else if(class == bytes32("Crude")){
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
        reward.class = bytes32("Undified");
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
