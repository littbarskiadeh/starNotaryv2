// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721  {

    struct Star {
        string name;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    constructor() ERC721("StarNotary","SN") {    }

    
    // Create Star using the Struct
    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
        // setApprovalForAll(address(this), true);
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sell the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }

    // function _make_payable(address x) internal pure returns (address payable) {
    //     //    address payable payableAddress = payable(x);
    //     return address(uint160(x));
    //     // return payableAddress;
    // }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        // approve(msg.sender, _tokenId); // added for test
        transferFrom(ownerAddress, msg.sender, _tokenId);
        address payable ownerAddressPayable = payable(ownerAddress);
        ownerAddressPayable.transfer(starCost);

        if(msg.value > starCost) {
            // ownerAddressPayable.transfer(starCost);
            address payable callerAddressPayable = payable(msg.sender);

            callerAddressPayable.transfer(msg.value - starCost);
        }
    }

}
