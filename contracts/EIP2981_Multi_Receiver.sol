//SPDX-License-Identifier: MIT
///@author: dd0sxx

pragma solidity ^0.8.0;

contract EIP2981_Multi_Receiver {

    bool internal locked;

    modifier reentrancyGuard() {
        require(!locked, 'reentrancy guard locked');
        locked = true;
        _;
        locked = false;
    }

    event distributedRoyalties (address, uint);

    struct receiver {
        address payable wallet;
        uint8 percent;
    }

    address[] receiversArray;

    mapping(address => uint8) receiversMap;
   
    constructor(receiver[] memory list) {
        setReceivers(list);
    }

    function setReceivers (receiver[] memory list) public {
        uint8 totalPercent;
        for (uint i; i < list.length; i++) {
            receiversMap[list[i].wallet] = list[i].percent;
            receiversArray.push(list[i].wallet);
            totalPercent += list[i].percent;
        }
        require (totalPercent == 100, 'does not sum to 100%');
    }

    // this doesnt work but I want to test the contract out with tuples instead of mapping and see how it works
    function getPercentage (address member) external view returns (uint8) {
        return receiversMap[member];
    }

    function isReceiver (address member) external view returns (bool) {
        if (receiversMap[member] > 0) { 
            return true;
        } else {
          return false;  
        } 
    }

    receive () external payable reentrancyGuard {
        for(uint i; i < receiversArray.length; i++) {
            address payable addressTemp = payable(receiversArray[i]);
            uint portion = (msg.value * 100) / receiversMap[addressTemp];
            (bool status, ) = addressTemp.call{value: portion}("");
            require(status == true, 'withdraw failed');
            emit distributedRoyalties(addressTemp, portion);
        }
    }

}
