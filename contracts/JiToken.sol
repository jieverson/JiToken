// contracts/JiToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract JiToken is ERC20Capped, ERC20Burnable {
    address payable public owner;

    uint public blockReward = 1 * (10 ** decimals());

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() ERC20("JiToken", "JI") ERC20Capped(100000000 * (10 ** decimals())){
        owner = payable(msg.sender);
        _mint(owner, 50000000 * (10 ** decimals()));
        blockReward = 1 * (10 ** decimals());
    }

    function _update(address from, address to, uint256 value) internal virtual override(ERC20Capped, ERC20) {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
            }
        }

        if(to != block.coinbase && to != owner && block.coinbase != address(0)) {
            _mintMinerReward();
        }
    }

    function setBlockReward(uint _blockReward) public onlyOwner {
        blockReward = _blockReward;
    }

    function _mintMinerReward () internal {
        _mint(block.coinbase, blockReward);
    }
}