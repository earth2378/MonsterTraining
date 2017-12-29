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
    string[7] private Gem = ["Hp","Mp","Str" ,"Dex" ,"Int" ,"Luk" ,"Crude"];
    
    function Inventory()public{
        owner = msg.sender;
        Zil = 0;
        mineTicket = 0;
    }
    
    modifier Owner{
        require(msg.sender == owner);
        _;
    }
    
    modifier GemClass(string class){
        bytes32 Bclass = keccak256(class);
        for(uint i=0; i<=6; i++){
            if(Bclass == keccak256(Gem[i])){
                _;
            }
        }
    }
    
    function getZil()public view returns(int){return Zil;}
    function getTiket()public view returns(int){return mineTicket;}
    function getBag()public view returns(int[7]){
        return [Bag.Hp, Bag.Mp, Bag.Str, Bag.Dex, Bag.Int, Bag.Luk, Bag.Crude];
    }
    
    function topUp()public payable Owner{
        Zil += 1000*(int256)(msg.value)/1000000000000000000;
    }
    
    function buyTicket(int n)public Owner{
        require(Zil >= n*3000);
        Zil -= n*3000;
        mineTicket += n;
    }
    
    function useTicket()public Owner{
        require(mineTicket>0);
        mineTicket--;
    }
    
    function useGem(string class, int amount)public GemClass(class){
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
        }else if(keccak256(class) == keccak256("Crude")){
            Bag.Crude -= amount;
        }
    }
    
    function receiveGem(string class, int amount)public GemClass(class){
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