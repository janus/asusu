pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "@chainlink/contracts/src/v0.5/dev/AggregatorInterface.sol";
import "@chainlink/contracts/src/v0.5/ChainlinkClient.sol";
//import "@chainlink/contracts/src/v0.5/interfaces/AggregatorInterface.sol";
//import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/interfaces/AggregatorInterface.sol";


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

contract MyContract is ChainlinkClient {

    using SafeMath for uint256;
    address public owner;

    AggregatorInterface internal priceFeed;
    AggregatorInterface internal ipriceFeed;
    
    address linkUSD = 0xc21c178fE75aAd2017DA25071c54462e26d8face;
    address daiUSD = 0xec3cf275cAa57dD8aA5c52e9d5b70809Cb01D421;


    address[] tokens = [linkUSD, daiUSD];

    address dai = 0x00D811B7d33cECCFcb7435F14cCC274a31CE7F5d;
    address link = 0x20fE562d797A42Dcb3399062AE9546cd06f63280;

    address[] erc20tokens = [link, dai];



    int256 USDREFMultiply = 100000000;
    uint256 twoHUSD = 200;

    struct userTx{
        uint256 time;
        uint256 rateTimestamp;
        uint256 amount;
        address user;
    }

    struct transactions{
        userTx[20] tx;
    }
    mapping(address => transactions) internal tokenAsusu;

    transactions tranx;
    uint linkUSDIndex = 0;
    uint daiUSDIndex = 0;

    enum Position {Active, Open, Ended}
    struct State {
        Position position;
        uint256 total;
        uint256 amountGivingPerMonth;
        uint gindex;
        uint tindex;
    }

    uint lenMax = 200;

    mapping(address => State) public asusuState;
    event DistributedTokens(
        address indexed _contract,
        address indexed _recipient,
        uint256 _amount
    );
    event SentTokens(
        address indexed _token,
        address indexed _sender,
        uint256 _amount
    );
    /**
     * Network: Ropsten
     * Aggregator: ETH/USD
     * Address: 0x8468b2bDCE073A157E560AA4D9CcF6dB1DB98507
     */
    constructor() public {
        asusuState[linkUSD] = State(Position.Open, 0, 0, 0, 0);
        asusuState[daiUSD] = State(Position.Open, 0, 0, 0, 0);
        //asusuState[daii] = State(Position.Open, 0, 0, 0, 0);
        priceFeed = AggregatorInterface(linkUSD);
        ipriceFeed = AggregatorInterface(daiUSD);
        //ipriceFeed = AggregatorInterface(daii);

        owner = msg.sender;

    }


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
  

    /**
     * Deposit token for asusu
     */
    function depositToken(address token) public payable returns (bool){
        uint index = 0;
        int256 rate;
        uint256 _value;
        uint indx;
        uint256  total;
        uint i;
        uint256 time;
        int256 price;
        while(index < 2) {
            if (token == erc20tokens[i]) {
                if(asusuState[tokens[i + 1]].position == Position.Active) {
                    return false;
                }
           
                time = ipriceFeed.latestTimestamp();
                price = ipriceFeed.latestAnswer();

 

                rate = price / USDREFMultiply;
                _value = twoHUSD / uint256(rate);

                ERC20 tken = ERC20(token);
                tken.approve(msg.sender, _value);
                require(_value <= msg.sender.balance, "You have insufficient amount for this transaction");
                require(tken.transferFrom(msg.sender, address(this), _value) == true, "Could not send tokens to the contract");

                indx = asusuState[tokens[i + 1]].gindex;
                tranx = tokenAsusu[tokens[i + 1]];
                tranx.tx[indx] = userTx(now, time, _value, msg.sender);
                asusuState[tokens[i + 1]].gindex = asusuState[tokens[i + 1]].gindex + 1;
                if(asusuState[tokens[i + 1]].gindex == lenMax) {
                    total = 0;
                    uint l = 0;
                    while(l < lenMax) {
                        total = total + tranx.tx[l].amount;
                    }
                    asusuState[tokens[i + 1]] = State(Position.Active, total, total /lenMax, 0, 0);

                } else {
                    tokenAsusu[tokens[i + 1]] = tranx;
                }
                emit SentTokens(token, msg.sender, _value);
                return true;
            }
            i++;

        }
    }

    function distributeTokens(address _token) public onlyOwner {
        uint k = 0;
        address recipient;
        while(k < lenMax){
            if(asusuState[tokens[k]].position == Position.Active) {
                if(now >= tokenAsusu[tokens[k]].tx[asusuState[tokens[k]].tindex].time + (25 * 1 days)) {
                    ERC20 erc20token = ERC20(_token);
                    recipient = tokenAsusu[tokens[k]].tx[asusuState[tokens[k]].tindex].user;
                    asusuState[tokens[k]].tindex = asusuState[tokens[k]].tindex + 1;
                    require(
                        erc20token.transfer(recipient, asusuState[tokens[k]].amountGivingPerMonth),
                        "Token transfer could not be executed.");
                    emit DistributedTokens(_token, recipient, asusuState[tokens[k]].amountGivingPerMonth);
                }
            }
            k++;
        }
        if(k == lenMax) {
            asusuState[tokens[k]].position == Position.Open;
        }
    }


    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    //function () public payable {}

}