pragma solidity ^0.4.18;

import "./Mine.sol";
import "./Inventory.sol";
import "./Monster.sol";

contract MonsterTraining{
    mapping(address => Monster)realm;
}