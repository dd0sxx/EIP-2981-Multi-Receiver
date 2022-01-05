//SPDX-License-Identifier: MIT
///@author: dd0sxx

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EIP2981_Multi_Receiver {

    struct receiver {
        address wallet;
        uint8 percent;
    }


    receiver[] receivers;
   
    constructor(receiver[] memory list) {
        receivers = list;
    }

    receive () external payable {
        
    }

}
