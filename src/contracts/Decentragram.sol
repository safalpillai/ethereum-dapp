pragma solidity ^0.5.0;

contract Decentragram {
  string public name = 'Decentragram';
  
  // store images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  /**
   * Models
   */
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }
  
  /**
   * Events
   */
  event ImageCreated(
    uint id,
    string hash, 
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  /**
   * Create Images
   */
  function uploadImage(
    string memory _imgHash,
    string memory _description
  ) public {
    // validate function args
    require(bytes(_description).length > 0, 'no description provided');
    require(bytes(_imgHash).length > 0, 'no hash provided');
    require(msg.sender != address(0x0), 'no sender found');

    // increment image id
    imageCount ++;
    // add image to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
    // trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  /**
   * Tip Images
   */
  function tipImageOwner(uint _id) public payable {
    // validate id
    require(_id > 0 && _id <= imageCount);
    // fetch image
    Image memory _image = images[_id];
    // fetch author
    address payable _author = _image.author;
    // pay author with ether
    address(_author).transfer(msg.value);
    // increment tip amount of image
    _image.tipAmount = _image.tipAmount + msg.value;
    // update the image
    images[_id] = _image;
    // trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}