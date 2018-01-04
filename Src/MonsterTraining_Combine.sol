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

contract Inventory{
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

    modifier GemClass(bytes32 class){
        for(uint i=0; i<=6; i++){
            if(class == keccak256(Gem[i])){
                _;
            }
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

    function receiveGem(bytes32 class, int amount)public Owner Valid GemClass(class){
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
        }
    }
}

contract Monsters{
    Random random = new Random();

    struct Realm{
        address owner;
        mapping(string => Monster)realm;
        string[] index;
        string cm;
        bool valid;
    }
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

    mapping(address => Realm)userRealm;

    function Monsters()public{
    }

    modifier monsterValid{
        require(userRealm[msg.sender].realm[userRealm[msg.sender].cm].valid == true);
        _;
    }

    modifier nonNegative(int value){
        require(value >= 0);
        _;
    }

    modifier Owner{
        require(msg.sender == userRealm[msg.sender].owner);
        _;
    }
    modifier Valid{
        require(userRealm[msg.sender].valid == true);
        _;
    }
    function userValid()public view returns(bool){return userRealm[msg.sender].valid;}
    function getCM()public constant returns(bytes32){return stringToBytes32(userRealm[msg.sender].cm);}
    function getStat(string name)public constant returns(int[6]){
        Monster storage tmp = userRealm[msg.sender].realm[name];
        return [tmp.Hp,tmp.Mp,tmp.Str,tmp.Dex,tmp.Int,tmp.Luk];
    }
    function getValid(string name)public constant returns(bool){return userRealm[msg.sender].realm[name].valid;}
    function getRace()public constant returns(string){return userRealm[msg.sender].realm[userRealm[msg.sender].cm].Race;}
    function getName(uint i)public constant returns(string){return userRealm[msg.sender].index[i];}
    function loadStat()public view returns(int[6]){
        Monster storage myMonster = userRealm[msg.sender].realm[userRealm[msg.sender].cm];
        return [myMonster.Hp,myMonster.Mp,myMonster.Str,myMonster.Dex,myMonster.Int,myMonster.Luk];
    }

    function initRealm()public{
        Realm storage myRealm = userRealm[msg.sender];
        myRealm.owner = msg.sender;
        myRealm.valid = true;
    }

    function load(string name)public Owner Valid{
        require(userRealm[msg.sender].realm[name].valid == true);
        userRealm[msg.sender].cm = name;

    }

    function hatch(string name)public Owner Valid{
        Realm storage myMonster = userRealm[msg.sender];
        require(myMonster.realm[name].valid == false);
        myMonster.index.push(name);
        myMonster.realm[name].valid = true;
        uint randomNum = random.randomSourceStat(name);
        initRace(name,randomNum);
        initStat(name,randomNum);
        initExtraStat(name,myMonster.realm[name].Race,randomNum);
    }

    function upgradeHp (int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Hp  += value;}
    function upgradeMp (int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Mp  += value;}
    function upgradeStr(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Str += value;}
    function upgradeDex(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Dex += value;}
    function upgradeInt(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Int += value;}
    function upgradeLuk(int value)public monsterValid nonNegative(value) Owner Valid{userRealm[msg.sender].realm[userRealm[msg.sender].cm].Luk += value;}

    function initRace(string name,uint n)private{
        userRealm[msg.sender].realm[name].Race = bytes32ToString(random.raceRandom(n));
    }
    function initStat(string name,uint n)private{
        int[6] memory status = random.statsRandom(n);
        Realm storage myMonster = userRealm[msg.sender];
        myMonster.realm[name].Hp  = status[0];
        myMonster.realm[name].Mp  = status[1];
        myMonster.realm[name].Str = status[2];
        myMonster.realm[name].Dex = status[3];
        myMonster.realm[name].Int = status[4];
        myMonster.realm[name].Luk = status[5];
    }
    function initExtraStat(string name,string race,uint n)private{
        bytes32 tmp = sha256(race);
        Realm storage myMonster = userRealm[msg.sender];
        if(tmp == sha256("Slime")){
            int[6] memory extraS = random.extraStatsRandomSlime(n);
            myMonster.realm[name].Hp  = extraS[0];
            myMonster.realm[name].Mp  = extraS[1];
            myMonster.realm[name].Str = extraS[2];
            myMonster.realm[name].Dex = extraS[3];
            myMonster.realm[name].Int = extraS[4];
            myMonster.realm[name].Luk = extraS[5];
        }else{
            int[2] memory extra = random.extraStatRandom(n);
            if(tmp == sha256("Bear")){
                myMonster.realm[name].Str += extra[0];
                myMonster.realm[name].Hp  += extra[1]*10;
            }
            if(tmp == sha256("Wolf")){
                myMonster.realm[name].Dex += extra[0];
                myMonster.realm[name].Luk += extra[1];
            }
            if(tmp == sha256("Fairy")){
                myMonster.realm[name].Int += extra[0];
                myMonster.realm[name].Mp  += extra[1]*10;
            }
            if(tmp == sha256("Rabbit")){
                myMonster.realm[name].Luk += extra[0];
                myMonster.realm[name].Dex += extra[1];
            }
        }
    }
    function stringToBytes32(string memory source)private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
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

contract MonsterTraining{

    Mine mine = new Mine();
    Inventory inventory;
    Monsters monsters;
    mapping(address => bytes32)passwordStorage;
    address GM;
    mapping(address => bytes32)selectedMonster;
    mapping(address => string[])userIndex;

    function MonsterTraining(address i, address m)public{
        GM = msg.sender;
        inventory = Inventory(i);
        monsters = Monsters(m);
    }
    function userMValid()public view returns(bool){return monsters.userValid();}
    function getBalance()public view returns(int){return inventory.getZil();}
    function mySelectedMonster()public view returns(bytes32){return selectedMonster[msg.sender];}
    function myBag()public view returns(int[7]){return inventory.getBag();}
    function myTicket()public view returns(int){return inventory.getTicket();}
    function loadStat()public view returns(int[6]){return monsters.loadStat();}
    function getMe()public view returns(address){return msg.sender;}
    function checkStat(string name)public view returns(int[6]){return monsters.getStat(name);}
    function monsterExist(string name)public view returns(bool){return monsters.getValid(name);}
    function getMyMonster(uint i)public view returns(string){return userIndex[msg.sender][i];}

    function register(string password)public{
        require(passwordStorage[msg.sender] == bytes32(0));
        passwordStorage[msg.sender] = keccak256(msg.sender,password);
        inventory.initBag();
        monsters.initRealm();
    }

    function topUp() public payable{
        uint tmp = msg.value/1000000000000000000;
        inventory.topUp(tmp);
    }

    function hatchMonster(string name)public{
        inventory.useEgg();
        monsters.hatch(name);
        userIndex[msg.sender].push(name);
    }

    function loadMonster(string name)public{
        monsters.load(name);
        selectedMonster[msg.sender] = monsters.getCM();
    }

    function buyTicket(int n)public{
        inventory.buyTicket(n);
    }
    function buyEgg(int n)public{
        inventory.buyEgg(n);
    }

    function mining(string word)public{
        inventory.useTicket();
        bytes32 classTmp;
        int amountTmp;
        bytes32 tmp = keccak256(word);
        (classTmp,amountTmp) = mine.mine(tmp);
        inventory.receiveGem(classTmp,amountTmp);
    }

    function useGem(string class, int amount)public{
        bytes32 classTmp = keccak256(class);
        inventory.useGem(classTmp,amount);
        if(classTmp == keccak256("Hp")){
            monsters.upgradeHp(amount*10);
        }else if(classTmp == keccak256("Mp")){
            monsters.upgradeMp(amount*10);
        }else if(classTmp == keccak256("Str")){
            monsters.upgradeStr(amount);
        }else if(classTmp == keccak256("Dex")){
            monsters.upgradeDex(amount);
        }else if(classTmp == keccak256("Int")){
            monsters.upgradeInt(amount);
        }else if(classTmp == keccak256("Luk")){
            monsters.upgradeLuk(amount);
        }else if(classTmp == keccak256("Crude")){
            //for exchange (Not implement yet)
        }
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
