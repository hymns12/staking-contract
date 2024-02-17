// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {

    function totalSupply() external view returns(bool);

    function balanceOf(address account) external view returns(bool);

    function transfer(address recipien, uint amount) external returns(bool);

    function allowance(address owner, address sender) external view returns(bool);

    function approve(address spender, uint amount) external returns(bool);

    function transferForm(address sender, address recipien, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);

}