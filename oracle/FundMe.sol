//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Importing interface which can map every contract from the origin
// Using named import for more convinience 
import {AggregatorV3Interface} from "@smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    function fund() public payable {
        //Rollback will be executed if predicate of require statement is false
        require(getConversionRate(msg.value) >= MINIMUM_USD, "didn't send enough ETH");
    }

    function getPrice() public view returns(uint256) {
        //Provide an address of origin contract giving conversions for ETH/USD
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x00);

        //Getting only the price from the .latestRoundData function response
        (,int256 price,,,) = priceFeed.latestRoundData();
    
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}