pragma solidity ^0.4.18;
contract Inventory{
    struct GemBag{
        int Hp;
        int Mp;
        int Str;
        int Dex;
        int Int;
        int Luk;
        int Crude;
    }
    
    GemBag Bag;
    int Zil;
    int mineTicket;
    address owner;
    
    function Inventory()public{
        owner = msg.sender;
        Zil = 0;
        mineTicket = 0;
    }
    
    modifier Owner{
        require(msg.sender == owner);
        _;
    }
    
    function getZil()public view returns(int){return Zil;}
    function getTiket()public view returns(int){return mineTicket;}
    
    
    function topUp()public payable Owner{
        Zil += 1000*(int256)(msg.value);
    }
    
    function buyTicket(int n)public Owner{
        require(Zil >= n*3000);
        Zil -= n*3000;
        mineTicket += n;
    }
    
    function useGem(string class, int amount)public{
        if(keccak256(class) == keccak256("Hp")){
            require(Bag.Hp >= amount);
            Bag.Hp -= amount;
        }else if(keccak256(class) == keccak256("Mp")){
            require(Bag.Mp >= amount);
            Bag.Mp -= amount;
        }else if(keccak256(class) == keccak256("Str")){
            require(Bag.Str >= amount);
            Bag.Str -= amount;
        }else if(keccak256(class) == keccak256("Dex")){
            require(Bag.Dex >= amount);
            Bag.Dex -= amount;
        }else if(keccak256(class) == keccak256("Int")){
            require(Bag.Int >= amount);
            Bag.Int -= amount;
        }else if(keccak256(class) == keccak256("Luk")){
            require(Bag.Luk >= amount);
            Bag.Luk -= amount;
        }
    }
    
    function receiveGem(string class, int amount)public{
        if(keccak256(class) == keccak256("Hp")){
            Bag.Hp += amount;
        }else if(keccak256(class) == keccak256("Mp")){
            Bag.Mp += amount;
        }else if(keccak256(class) == keccak256("Str")){
            Bag.Str += amount;
        }else if(keccak256(class) == keccak256("Dex")){
            Bag.Dex += amount;
        }else if(keccak256(class) == keccak256("Int")){
            Bag.Int += amount;
        }else if(keccak256(class) == keccak256("Luk")){
            Bag.Luk += amount;
        }else if(keccak256(class) == keccak256("Crude")){
            Bag.Crude += amount;
        }
    }
}