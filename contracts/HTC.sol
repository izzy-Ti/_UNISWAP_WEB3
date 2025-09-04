// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TinaToken is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint maxSupply = 3;


    //Variables to turn on and off the mint functions
    bool public publicMintOpen = false;
    bool public allowedListMintOpen = false;

    //Creating allowed users that can use allowedListMint

    mapping(address => bool) public allowedList;

    constructor()
        ERC721("TinaToken", "TNA")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/QmRKxo1A65A1V4jTk7Pf2Mz7yHSD8vNfasdzJgJnSNs5BA";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    function editMintWindow(bool _allowedListMintOpen, bool _publicMintOpen) public onlyOwner{
        allowedListMintOpen = _allowedListMintOpen;
        publicMintOpen = _publicMintOpen;
    }
    //Setting the allowedList addresses
    function setAllowList(address[] calldata _addresses) external onlyOwner { //accept the addresses as an array
        for(uint i=0; i< _addresses.length; i++){ // distributing each addresses with index of i
            allowedList[_addresses[i]] = true; // Setting of there bool to true
        }
    }

    //only allowed ppls can mint with this allowedList[]
    function allowListMint() public payable{
        require(allowedListMintOpen, "Sorry this mint is not avilabe for now");
        require(allowedList[msg.sender], "Your are not allowed user");
        require(msg.value == 0.003 ether , "Insuffcient balance"); //requireing payment to get the NFT
        internalMint();
    }
    //Add payment
    //Add total supply cuz we have limited baseURI number
    function publicMint() public payable{
        require(publicMintOpen, "Sorry this mint is not avilabe for now");
        require(msg.value == 0.03 ether , "Insuffcient balance"); //requireing payment to get the NFT
        internalMint();
    }

    //internal mint to simplify our code

    function internalMint() internal {
        require(totalSupply() < maxSupply, "The NFT is minted all"); // setting limit of 500
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}