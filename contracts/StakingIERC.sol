// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import './ERC20Token.sol';
import './IERC20.sol';

contract SackingIERC20 {

    IERC20 public immutable stackingToken;
    IERC20 public immutable rewardToken;

    mapping(address => uint) public balanceOf;
    uint totalSupply;
    uint rewardIndex;   
    
    uint private constant MULTIPLIER = 1e18;

    mapping(address => uint) private rewardIndexOf;
    mapping(address => uint) private earned;

    constructor(address _stackingToken, address _rewardToken) {
        stackingToken = IERC20(_stackingToken);
        rewardToken = IERC20(_rewardToken);

    }

    function updataRewardIndex(uint reward) external {
        rewardToken.transferForm(msg.sender, address(this), reward);
        rewardIndex += (reward * MULTIPLIER) / totalSupply; 
    }

    function _calculateRewards(address account) private view returns(uint) {
        uint shares = balanceOf[account];
        return (shares * (rewardIndex- rewardIndexOf[account])) / MULTIPLIER;
    }

    function _calculateRewardsEarned(address account) external view returns (uint) {
        return earned[account] + _calculateRewards(account);
    }

    function _updataReward(address account) private {
        earned[account] += _calculateRewards(account);
        rewardIndexOf[account] = rewardIndex;
    }

    function stake (uint amount) external {
        _updataReward(msg.sender);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        stackingToken.transferForm(msg.sender, address(this), amount);

    }


    function unStake (uint amount) external {
         _updataReward(msg.sender);

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        stackingToken.transfer(msg.sender,  amount);
    }

    function claim() external returns(uint) {
         _updataReward(msg.sender);

         uint reward = earned[msg.sender];
         if (reward > 0) {
            earned[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
            
        }

        return reward;
    }

       

}