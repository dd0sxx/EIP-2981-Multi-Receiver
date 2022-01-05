//SPDX-License-Identifier: MIT
///@author: dd0sxx

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EIP2981_Multi_Receiver {

    bool internal locked;

    modifier reentrancyGuard() {
        require(!locked, 'reentrancy guard locked');
        locked = true;
        _;
        locked = false;
    }

    struct receiver {
        address payable wallet;
        uint8 percent;
    }

    address[] receiversArray;

    mapping(address => uint8) receiversMap;
   
    constructor(receiver[] memory list) {
        for (uint i; i < list.length; i++) {
            receiversMap[list[i].wallet] = list[i].percent;
            receiversArray.push(list[i].wallet);
        }
    }

    receive () external payable reentrancyGuard {
        for(uint i; i < receiversArray.length; i++) {
            address payable addressTemp = payable(receiversArray[i]);
            uint portion = (msg.value * 100) / receiversMap[addressTemp];
            (bool status, ) = addressTemp.call{value: portion}("");
            require(status == true, 'withdraw failed');
        }
    }

}
