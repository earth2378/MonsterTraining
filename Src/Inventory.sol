pragma solidity ^0.4.18;

contract Inventory{
    //version 1.0.1
    struct Bag{
        address owner;
        GemBag bag;
        int mineTicket;
        int hatchEgg;
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
    string[8] private Item = ["Hp","Mp","Str" ,"Dex" ,"Int" ,"Luk" ,"Crude","Zil"];

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
    modifier GemClass(bytes32 class){
        for(uint i=0; i<=6; i++){
            if(class == keccak256(Item[i])) _;
        }
    }
    modifier ItemClass(bytes32 class){
        for(uint i=0; i<=7; i++){
            if(class == keccak256(Item[i]))_;
        }
    }

    function getZil()public view returns(int){return userInventory[msg.sender].zil;}
    function getTicket()public view returns(int){return userInventory[msg.sender].mineTicket;}
    function getEgg()public view returns(int){return userInventory[msg.sender].hatchEgg;}
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
        userInventory[msg.sender].zil += int256(value);
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

    function buyEgg(int n)public Owner Valid{
        Bag storage myBag = userInventory[msg.sender];
        require(myBag.zil >= n*5000);
        myBag.zil -= n*5000;
        myBag.hatchEgg += n;
    }

    function useEgg()public Owner Valid{
        require(userInventory[msg.sender].hatchEgg>0);
        userInventory[msg.sender].hatchEgg--;
    }

    function useGem(bytes32 class, int amount)public Owner Valid GemClass(class){
        GemBag storage myBag = userInventory[msg.sender].bag;
        if(class == keccak256("Hp")){
            require(myBag.Hp >= amount);
            myBag.Hp -= amount;
        }else if(class == keccak256("Mp")){
            require(myBag.Mp >= amount);
            myBag.Mp -= amount;
        }else if(class == keccak256("Str")){
            require(myBag.Str >= amount);
            myBag.Str -= amount;
        }else if(class == keccak256("Dex")){
            require(myBag.Dex >= amount);
            myBag.Dex -= amount;
        }else if(class == keccak256("Int")){
            require(myBag.Int >= amount);
            myBag.Int -= amount;
        }else if(class == keccak256("Luk")){
            require(myBag.Luk >= amount);
            myBag.Luk -= amount;
        }else if(class == keccak256("Crude")){
            myBag.Crude -= amount;
        }
    }

    function receiveItem(bytes32 class, int amount)public Owner Valid ItemClass(class){
        GemBag storage myBag = userInventory[msg.sender].bag;
        if(class == keccak256("Hp")){
            myBag.Hp += amount;
        }else if(class == keccak256("Mp")){
            myBag.Mp += amount;
        }else if(class == keccak256("Str")){
            myBag.Str += amount;
        }else if(class == keccak256("Dex")){
            myBag.Dex += amount;
        }else if(class == keccak256("Int")){
            myBag.Int += amount;
        }else if(class == keccak256("Luk")){
            myBag.Luk += amount;
        }else if(class == keccak256("Crude")){
            myBag.Crude += amount;
        }else if(class == keccak256("Zil")){
            topUp(uint(amount));
        }
    }
}
