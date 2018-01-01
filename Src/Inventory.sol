pragma solidity ^0.4.18;
contract Inventory{
    struct Bag{
        address owner;
        GemBag bag;
        int mineTicket;
        int zil;
        bool valid;
    }
    struct GemBag{
        int Hp;
        int Mp;
        int Str;
        int Dex;
        int Int;
        int Luk;
        int Crude;
    }
    mapping(address => Bag)userInventory;
    string[7] private Gem = ["Hp","Mp","Str" ,"Dex" ,"Int" ,"Luk" ,"Crude"];

    function Inventory()public{

    }

    modifier Owner{
        require(msg.sender == userInventory[msg.sender].owner);
        _;
    }
    modifier Valid{
        require(userInventory[msg.sender].valid == true);
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

    function getZil()public view returns(int){return userInventory[msg.sender].zil;}
    function getTicket()public view returns(int){return userInventory[msg.sender].mineTicket;}
    function getBag()public view returns(int[7]){
        GemBag storage myBag = userInventory[msg.sender].bag;
        return [myBag.Hp, myBag.Mp, myBag.Str, myBag.Dex, myBag.Int, myBag.Luk, myBag.Crude];
    }
    
    function initBag()public{
        Bag storage myBag = userInventory[msg.sender];
        myBag.owner = msg.sender;
        myBag.valid = true;
    }

    function topUp(uint value)public Owner Valid{
        userInventory[msg.sender].zil += 1000*int256(value);
    }

    function buyTicket(int n)public Owner Valid{
        Bag storage myBag = userInventory[msg.sender];
        require(myBag.zil >= n*3000);
        myBag.zil -= n*3000;
        myBag.mineTicket += n;
    }

    function useTicket()public Owner Valid{
        require(userInventory[msg.sender].mineTicket>0);
        userInventory[msg.sender].mineTicket--;
    }

    function useGem(string class, int amount)public Owner Valid GemClass(class){
        GemBag storage myBag = userInventory[msg.sender].bag;
        if(keccak256(class) == keccak256("Hp")){
            require(myBag.Hp >= amount);
            myBag.Hp -= amount;
        }else if(keccak256(class) == keccak256("Mp")){
            require(myBag.Mp >= amount);
            myBag.Mp -= amount;
        }else if(keccak256(class) == keccak256("Str")){
            require(myBag.Str >= amount);
            myBag.Str -= amount;
        }else if(keccak256(class) == keccak256("Dex")){
            require(myBag.Dex >= amount);
            myBag.Dex -= amount;
        }else if(keccak256(class) == keccak256("Int")){
            require(myBag.Int >= amount);
            myBag.Int -= amount;
        }else if(keccak256(class) == keccak256("Luk")){
            require(myBag.Luk >= amount);
            myBag.Luk -= amount;
        }else if(keccak256(class) == keccak256("Crude")){
            myBag.Crude -= amount;
        }
    }

    function receiveGem(string class, int amount)public Owner Valid GemClass(class){
        GemBag storage myBag = userInventory[msg.sender].bag;
        if(keccak256(class) == keccak256("Hp")){
            myBag.Hp += amount;
        }else if(keccak256(class) == keccak256("Mp")){
            myBag.Mp += amount;
        }else if(keccak256(class) == keccak256("Str")){
            myBag.Str += amount;
        }else if(keccak256(class) == keccak256("Dex")){
            myBag.Dex += amount;
        }else if(keccak256(class) == keccak256("Int")){
            myBag.Int += amount;
        }else if(keccak256(class) == keccak256("Luk")){
            myBag.Luk += amount;
        }else if(keccak256(class) == keccak256("Crude")){
            myBag.Crude += amount;
        }
    }
}
