pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorInterface.sol";


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of this contract");
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Can't transfer to empty address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract PriceConsumer is Ownable,VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;

    AggregatorInterface internal priceFeed;
    
    address ethUSD = 0x8468b2bDCE073A157E560AA4D9CcF6dB1DB98507;
    address linkUSD = 0xc21c178fE75aAd2017DA25071c54462e26d8face;
    address daiUSD = 0xec3cf275cAa57dD8aA5c52e9d5b70809Cb01D421;


    address[] tokens = [ethUSD, linkUSD, daiUSD];

    address dai = 0xad6d458402f60fd3bd25163575031acdce07538d;
    address link = 0x20fE562d797A42Dcb3399062AE9546cd06f63280;

    address[] erc20tokens = [link, dai];


    uint256 price;
    uint256 time;
    uint256 USDREFMultiply = 100000000;
    uint256 twoHUSD = 200;

    struct userDetail{
        uint256 time;
        uint256 rateTimestamp;
        uint256 amount;
        address user;
    }

    userDetail[20] userDetails;
    mapping(address => userDetails) public tokenAsusu;

    uint ethUSDIndex = 0;
    uint linkUSDIndex = 0;
    uint daiUSDIndex = 0;

    enum Position {Active, Open, Ended}
    struct State{
        Position position;
        uint256 total;
        uint256 amountGivingPerMonth;
        uint gindex;
        uint tindex;
    }

    address owner;
    uint lenMax = 200;

    mapping(address => State) public asusuState;
    event DistributedTokens(
        address indexed _contract,
        address indexed _recipient,
        uint256 _amount
    );
    /**
     * Network: Ropsten
     * Aggregator: ETH/USD
     * Address: 0x8468b2bDCE073A157E560AA4D9CcF6dB1DB98507
     */
    constructor() public {
        asusuState[ethUSD] = State(Open, 0, 0, 0);
        asusuState[linkUSD] = State(Open, 0, 0, 0);
        asusuState[daiUSD] = State(Open, 0, 0, 0);
        owner = msg.sender;
    }
  
    /**
     * Returns the latest price
     */
    function getLatestPrice() internal view returns (int256) {
        return priceFeed.latestAnswer();
    }

    /**
     * Returns the timestamp of the latest price update
     */
    function getLatestPriceTimestamp() internal view returns (uint256) {
        return priceFeed.latestTimestamp();
    }

    /**
     * Get rate and time stamp
     */
    function getLatestPriceaAndTimestamp(AggregatorInterface priceFeed) internal returns(uint256, uint256){
        return (priceFeed.latestAnswer(), priceFeed.latestTimestamp());
    }
    

    /**
     * Deposit token for asusu
     */
    function depositToken(address token) public payable returns (bool){
        uint index = 0;
        while(index < 2) {
            if (token == erc20tokens[i]) {
                if(asusuState[tokens[i + 1]].position == Active) {
                    return false;
                }
                priceFeed = AggregatorInterface(tokens[i + 1]);
                (price, time) = getLatestPriceaAndTimestamp(priceFeed);

                uint256 rate = price.div(USDREFMultiply);
                uint256 _value = twoHUSD.div(rate);

                ERC20 tken = ERC20(token);
                tken.approve(msg.sender, _value);
                require(_value <= tken.balanceOf(msg.sender), "You have insufficient amount for this transaction");

                token.transferFrom(msg.sender,  address(this), _value);
                uint indx = asusuState[tokens[i + 1]].gindex;
                tokenAsusu[tokens[i + 1]][indx] = userDetail(now, time, _value, msg.sender);
                asusuState[tokens[i + 1]].gindex = asusuState[tokens[i + 1]].gindex + 1;
                if(asusuState[tokens[i + 1]].gindex == lenMax) {

                    uint256  total = 0;
                    uint i = 0;
                    while(i < lenMax) {
                        total = total + tokenAsusu[tokens[i + 1]][i].amount;
                    }
                    uint256 returnValue = total.div(lenMax);
                    asusuState[token] = State(Active, total, returnValue, 0, 0);

                }
                Transfer(token, address(this), _value);
                return true;
            }
            i++;

        }
        if(asusuState[ethUSD].position == Active) {
            return false;
        }
        priceFeed = AggregatorInterface(tokens[0]);
        (price, time) = getLatestPriceaAndTimestamp(priceFeed);

        uint256 rate = price.div(USDREFMultiply);
        uint256 _value = twoHUSD.div(rate);

        require(_value <= msg.sender.balanceOf(), "You have insufficient amount for this transaction");

        msg.sender.transfer(address(this), _value);
        uint indx = asusuState[ethUSD].gindex;
        tokenAsusu[ethUSD][indx] = userDetail(now, time, _value, msg.sender);
        asusuState[ethUSD].index = asusuState[ethUSD].index + 1;
        if( asusuState[ethUSD].index == lenMax) {
            uint256  total = 0;
            uint i = 0;
            while(i < lenMax) {
                total = total + tokenAsusu[ethUSD][i].amount;
            }
            uint256 returnValue = total.div(lenMax);
            asusuState[ethUSD] = State(Active, total, returnValue, 0);

        }
        Transfer(ethUSD, address(this), _value);
        return true;
    }

    function distributeTokens(address _token) public onlyOwner {
        uint i = 0;
        while(i < lenMax){
            if(asusuState[tokens[i]].position == Active && i == 0) {
                address recipient = tokenAsusu[tokens[i]][asusuState[tokens[i]].tindex].user;
                asusuState[tokens[i]].tindex = asusuState[tokens[i]].tindex + 1;
                require(
                    address(this).transfer(recipient, asusuState[tokens[i]].amountGivingPerMonth),
                    "Token transfer could not be executed.");
                emit DistributedTokens(ethUSD, recipient, asusuState[tokens[i]].amountGivingPerMonth);
            } else {
                ERC20 erc20token = ERC20(_tokens);
                address recipient = tokenAsusu[tokens[i]][asusuState[tokens[i]].tindex].user;
                asusuState[tokens[i]].tindex = asusuState[tokens[i]].tindex + 1;
                require(
                    erc20token.transfer(recipient, asusuState[tokens[i]].amountGivingPerMonth),
                    "Token transfer could not be executed.");
                emit DistributedTokens(_token, recipient, asusuState[tokens[i]].amountGivingPerMonth);
            }
            i++;
        }
    }

    //function () public payable {}

}