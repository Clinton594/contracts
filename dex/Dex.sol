// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Dex {
    uint16 nextOrderId;
    bytes32 constant DAI = bytes32("DAI");
    //Token structure
    struct Token {
        bytes10 ticker;
        address tokenAddress;
    }
    // Order structure
    struct Order {
        uint256 id;
        Side side;
        bytes10 ticker;
        uint256 amount;
        uint256 filled;
        uint256 price;
        uint256 date;
    }
    // store all tokens added by the admin
    mapping(bytes10 => Token) public tokens;
    // Keeps track of all token tickers in the Dex
    bytes10[] public allTickers;
    // Define the admin
    address public admin;
    // store balances of tradters
    mapping(address => mapping(bytes10 => uint256)) public traderBalance;
    // Order type
    enum Side {
        BUY,
        SELL
    }
    // Orderbook : mapping of ticker to mapping of order type to array of orders sorted by price-time priority
    mapping(bytes11 => mapping(uint256 => Order[])) public orderbook;

    constructor() {
        admin = msg.sender;
    }

    function addToken(bytes10 _ticker, address _tokenAddress)
        externals
        onlyAdmin
    {
        tokens[_ticker] = Token(_ticker, _tokenAddress);
        allTickers.push(_ticker);
    }

    function deposit(uint256 _amount, bytes10 _ticker) external tokenExists {
        IERC20(tokens[_ticker].tokenAddress).transferFrom(
            msg.sender, //From sender
            address(this), //This smart contract
            _amount
        );
        traderBalance[msg.sender][_ticker] += _amount;
    }

    function withdraw(uint256 _amount, bytes10 _ticker) external {
        require(
            traderBalance[msg.sender][_ticker] >= _amount,
            "Insufficient balance"
        );
        traderBalance[msg.sender][_ticker] -= _amount;
        IERC20(tokens[_ticker].tokenAddress).transfer(
            msg.sender, //To sender
            _amount
        );
    }

    function createLimitOrder(
        bytes10 _ticker,
        uint256 _amount,
        uint256 _price,
        Side _orderType
    ) external tokenExists(_ticker) {
        require(_ticker != DAI, "Can not trade dai");
        if (_orderType == Side.SELL) {
            require(
                traderBalance[msg.sender][_ticker] >= _amount,
                "INSUFFICIENT TOKEN BALANCE"
            );
        } else {
            require(
                traderBalance[msg.sender][bytes32(DAI)] >= _amount * _price,
                "DAI BALANCE TOO LOW"
            );
        }
        Order order = orderbook[ticker][uint256(_orderType)];
        ord
    }

    modifier tokenExists(bytes10 _ticker) {
        require(
            tokens[_ticker].tokenAddress != address(0),
            "Token does not exist"
        );
        _;
    }
    modifier onlyAdmin() {
        require(admin == msg.sender, "Only Admin operation");
        _;
    }
}
