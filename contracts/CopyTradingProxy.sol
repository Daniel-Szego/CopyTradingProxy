pragma solidity >=0.4.21 <0.6.0;

contract CopyTradingProxy {

  // master trader
  address public master;
  // DEX address
  address public dex;
  // max possible number of followers
  uint public maxNrOfFollowers;
  // number of followers
  uint public nrOfFollowers;
  // follower addresses
  address[] public followers;

  // CONSTRUCTORS
  constructor(address _dex) public {
    master = msg.sender;
    maxNrOfFollowers = 5;
    dex = _dex;
  }

  // MODIFIERS 
  // only master can execute
  modifier onlyMaster () {
    require(msg.sender == master);
    _;
  }

  // only follower can execute
  modifier notMaster () {
    require(msg.sender != master);
    _;
  }

  // FUNCTIONS 
  // add follower to the contract
  function addFollower(address _followerAddress) notMaster() public {
      require(nrOfFollowers < maxNrOfFollowers);
      require(!this.isInFollowers(_followerAddress));
      followers.push(_followerAddress);
      nrOfFollowers += 1;
      emit FollowerAddedEvent(_followerAddress);
  }

  // add follower to the contract
  function removeFollower(address _followerAddress) notMaster() public {
      require(this.isInFollowers(_followerAddress));

      // deleting without a gap with minimal gas ?

      emit FollowerRemovedEvent(_followerAddress);
  }

  // creating order to the DEX via the proxy contract
  function order(address _token, uint _amount) onlyMaster() public {

      emit OrderCreatedEvent(msg.sender, _token, _amount);
  }
  

  // VIEW FUNCTIONS 
  // is address in the follower list
  function isInFollowers(address _followerAddress) public returns (bool) {
        for (uint i=0; i<maxNrOfFollowers; i++) {
            if (followers[i] == _followerAddress){
                return true;    
            }
        }
    return false;
  }

  // EVENTS 
  // event raised at follower added
  event FollowerAddedEvent(address follower);

  // event raised at follower removed
  event FollowerRemovedEvent(address follower);

  // event raised at creating the order
  event OrderCreatedEvent(address follower, address token, uint amount);

}