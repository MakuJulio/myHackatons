// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract GlobalToken{
    //Users balance
    mapping(address => uint256) private _balances;
    //¿Is an admin?
    mapping(address => bool) private _admins;
    //¿Is an user?
    mapping(address => bool) private _users;
    //¿Is a tp? aka third party
    mapping(address => bool) private _tps;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address private _deployer;

    event Transfer(address from, address to, uint256 amount);
    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    modifier onlyDeployer(){
        require(_deployer == msg.sender, "You are not the deployer");
        _;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function setAdmin(address account) public onlyDeployer returns (bool) {
        require(account != address(0), "admin cant be a zero address");
        _admins[account] = true;
        return true;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        address sender = msg.sender;
        if(_users[sender] && _tps[to]){
            _transferUserToTP(sender, to, amount);
            return true;  
        }else if(_admins[sender] && _users[to]){
            _mint(to, amount);
            return true;  
        }else if(_tps[sender]){
            _burn(_tps[sender], amount);
            return true;
        }

        return false;
    }
    
    function _transferUserToTP(address from, address to, uint256 amount) internal {
        require(from != address(0), "transfer from the zero address");
        require(to != address(0), "transfer to the zero address");
        uint256 paymentAmount = 0;

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
        }
        _balance[to] += amount;
            //Decidir qué hacer con los token gastados ¿burn?
            //Donde está la cash que se envía, en el balance de este contrato o en un vault o dónde?
            //Calcular paymentAmount
        (bool result,) = address(this).call{value:paymentAmount}("");
            require(result, "Something goes wrong with the payment");
    

        emit Transfer(from, to, amount);
    } 


    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "mint to the zero address");

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }
    
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }
    
}
