pragma solidity ^0.4.24;


/**
 * @title IERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface IERC165 {

  /**
   * @notice Query if a contract implements an interface
   * @param interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 interfaceId)
    external
    view
    returns (bool);
}

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721 is IERC165 {

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );
  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );
  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  function balanceOf(address owner) public view returns (uint256 balance);
  function ownerOf(uint256 tokenId) public view returns (address owner);

  function approve(address to, uint256 tokenId) public;
  function getApproved(uint256 tokenId)
    public view returns (address operator);

  function setApprovalForAll(address operator, bool _approved) public;
  function isApprovedForAll(address owner, address operator)
    public view returns (bool);

  function transferFrom(address from, address to, uint256 tokenId) public;
  function safeTransferFrom(address from, address to, uint256 tokenId)
    public;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes data
  )
    public;
}



/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721Enumerable is IERC721 {
  function totalSupply() public view returns (uint256);
  function tokenOfOwnerByIndex(
    address owner,
    uint256 index
  )
    public
    view
    returns (uint256 tokenId);

  function tokenByIndex(uint256 index) public view returns (uint256);
}



/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safeTransfer`. This function MUST return the function selector,
   * otherwise the caller will revert the transaction. The selector to be
   * returned can be obtained as `this.onERC721Received.selector`. This
   * function MAY throw to revert and reject the transfer.
   * Note: the ERC721 contract address is always the message sender.
   * @param operator The address which called `safeTransferFrom` function
   * @param from The address which previously owned the token
   * @param tokenId The NFT identifier which is being transferred
   * @param data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes data
  )
    public
    returns(bytes4);
}


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721Metadata is IERC721 {
  function name() external view returns (string);
  function symbol() external view returns (string);
  function tokenURI(uint256 tokenId) external view returns (string);
}



/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

/**
 * Utility library of inline functions on addresses
 */
library Address {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param account address of the account to check
   * @return whether the target address is a contract
   */
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(account) }
    return size > 0;
  }

}


/**
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract ERC165 is IERC165 {

  bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) private _supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor()
    internal
  {
    _registerInterface(_InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 interfaceId)
    external
    view
    returns (bool)
  {
    return _supportedInterfaces[interfaceId];
  }

  /**
   * @dev internal method for registering an interface
   */
  function _registerInterface(bytes4 interfaceId)
    internal
  {
    require(interfaceId != 0xffffffff);
    _supportedInterfaces[interfaceId] = true;
  }
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 is ERC165, IERC721 {

  using SafeMath for uint256;
  using Address for address;

  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

  // Mapping from token ID to owner
  mapping (uint256 => address) private _tokenOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) private _tokenApprovals;

  // Mapping from owner to number of owned token
  mapping (address => uint256) private _ownedTokensCount;

  // Mapping from owner to operator approvals
  mapping (address => mapping (address => bool)) private _operatorApprovals;

  bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
  
  // slot implementation
  address public implementation_slot;
  
  event PaymentReceived(
    address indexed sender,
    uint256 value
  );
  
  event PaymentLog(
      string uri,
      uint256 hash
  );
  
  // address owned erc721 tokens
  mapping (address => uint256[]) public addressOwnedTokenIds;
  
  /*
   * 0x80ac58cd ===
   *   bytes4(keccak256('balanceOf(address)')) ^
   *   bytes4(keccak256('ownerOf(uint256)')) ^
   *   bytes4(keccak256('approve(address,uint256)')) ^
   *   bytes4(keccak256('getApproved(uint256)')) ^
   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
   */

  constructor()
    public
  {
    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(_InterfaceId_ERC721);
  }

  /**
   * @dev Gets the balance of the specified address
   * @param owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0));
    return _ownedTokensCount[owner];
  }

  /**
   * @dev Gets the owner of the specified token ID
   * @param tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 tokenId) public view returns (address) {
    address owner = _tokenOwner[tokenId];
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param to address to be approved for the given token ID
   * @param tokenId uint256 ID of the token to be approved
   */
  function approve(address to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(to != owner);
    require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

    _tokenApprovals[tokenId] = to;
    emit Approval(owner, to, tokenId);
  }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * Reverts if the token ID does not exist.
   * @param tokenId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
  function getApproved(uint256 tokenId) public view returns (address) {
    require(_exists(tokenId));
    return _tokenApprovals[tokenId];
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param to operator address to set the approval
   * @param approved representing the status of the approval to be set
   */
  function setApprovalForAll(address to, bool approved) public {
    require(to != msg.sender);
    _operatorApprovals[msg.sender][to] = approved;
    emit ApprovalForAll(msg.sender, to, approved);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param owner owner address which you want to query the approval of
   * @param operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
    address owner,
    address operator
  )
    public
    view
    returns (bool)
  {
    return _operatorApprovals[owner][operator];
  }

  /**
   * @dev Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
  */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  )
    public
  {
      require(false, "Don't support directly transfer.");
  }
  
  /**
   * @dev _Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
  */
  function _transferFrom(
    address from,
    address to,
    uint256 tokenId
  )
    internal
  {
    require(_isApprovedOrOwner(msg.sender, tokenId));
    require(to != address(0));

    _clearApproval(from, tokenId);
    _removeTokenFrom(from, tokenId);
    _addTokenTo(to, tokenId);

    emit Transfer(from, to, tokenId);
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   *
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
  */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  )
    public
  {
    // solium-disable-next-line arg-overflow
    safeTransferFrom(from, to, tokenId, "");
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes _data
  )
    public
  {
    transferFrom(from, to, tokenId);
    // solium-disable-next-line arg-overflow
    require(_checkOnERC721Received(from, to, tokenId, _data));
  }

  /**
   * @dev Returns whether the specified token exists
   * @param tokenId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
  function _exists(uint256 tokenId) internal view returns (bool) {
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  /**
   * @dev Returns whether the given spender can transfer a given token ID
   * @param spender address of the spender to query
   * @param tokenId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   *  is an operator of the owner, or is the owner of the token
   */
  function _isApprovedOrOwner(
    address spender,
    uint256 tokenId
  )
    internal
    view
    returns (bool)
  {
    address owner = ownerOf(tokenId);
    // Disable solium check because of
    // https://github.com/duaraghav8/Solium/issues/175
    // solium-disable-next-line operator-whitespace
    return (
      spender == owner ||
      getApproved(tokenId) == spender ||
      isApprovedForAll(owner, spender)
    );
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param to The address that will own the minted token
   * @param tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address to, uint256 tokenId) internal {
    require(to != address(0));
    _addTokenTo(to, tokenId);
    emit Transfer(address(0), to, tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address owner, uint256 tokenId) internal {
    _clearApproval(owner, tokenId);
    _removeTokenFrom(owner, tokenId);
    emit Transfer(owner, address(0), tokenId);
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * Note that this function is left internal to make ERC721Enumerable possible, but is not
   * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
   * @param to address representing the new owner of the given token ID
   * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function _addTokenTo(address to, uint256 tokenId) internal {
    require(_tokenOwner[tokenId] == address(0));
    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * Note that this function is left internal to make ERC721Enumerable possible, but is not
   * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
   * and doesn't clear approvals.
   * @param from address representing the previous owner of the given token ID
   * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function _removeTokenFrom(address from, uint256 tokenId) internal {
    require(ownerOf(tokenId) == from);
    _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
    _tokenOwner[tokenId] = address(0);
  }

  /**
   * @dev Internal function to invoke `onERC721Received` on a target address
   * The call is not executed if the target address is not a contract
   * @param from address representing the previous owner of the given token ID
   * @param to target address that will receive the tokens
   * @param tokenId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes _data
  )
    internal
    returns (bool)
  {
    if (!to.isContract()) {
      return true;
    }
    bytes4 retval = IERC721Receiver(to).onERC721Received(
      msg.sender, from, tokenId, _data);
    return (retval == _ERC721_RECEIVED);
  }

  /**
   * @dev Private function to clear current approval of a given token ID
   * Reverts if the given address is not indeed the owner of the token
   * @param owner owner of the token
   * @param tokenId uint256 ID of the token to be transferred
   */
  function _clearApproval(address owner, uint256 tokenId) private {
    require(ownerOf(tokenId) == owner);
    if (_tokenApprovals[tokenId] != address(0)) {
      _tokenApprovals[tokenId] = address(0);
    }
  }
}




contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
  // Mapping from owner to list of owned token IDs
  mapping(address => uint256[]) private _ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  // Array with all token ids, used for enumeration
  uint256[] private _allTokens;

  // Mapping from token id to position in the allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
  /**
   * 0x780e9d63 ===
   *   bytes4(keccak256('totalSupply()')) ^
   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
   *   bytes4(keccak256('tokenByIndex(uint256)'))
   */

  /**
   * @dev Constructor function
   */
  constructor() public {
    // register the supported interface to conform to ERC721 via ERC165
    _registerInterface(_InterfaceId_ERC721Enumerable);
  }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param owner address owning the tokens list to be accessed
   * @param index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
  function tokenOfOwnerByIndex(
    address owner,
    uint256 index
  )
    public
    view
    returns (uint256)
  {
    require(index < balanceOf(owner));
    return _ownedTokens[owner][index];
  }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
  function totalSupply() public view returns (uint256) {
    return _allTokens.length;
  }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * Reverts if the index is greater or equal to the total number of tokens
   * @param index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
  function tokenByIndex(uint256 index) public view returns (uint256) {
    require(index < totalSupply());
    return _allTokens[index];
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * This function is internal due to language limitations, see the note in ERC721.sol.
   * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
   * @param to address representing the new owner of the given token ID
   * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function _addTokenTo(address to, uint256 tokenId) internal {
    super._addTokenTo(to, tokenId);
    uint256 length = _ownedTokens[to].length;
    _ownedTokens[to].push(tokenId);
    _ownedTokensIndex[tokenId] = length;
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * This function is internal due to language limitations, see the note in ERC721.sol.
   * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
   * and doesn't clear approvals.
   * @param from address representing the previous owner of the given token ID
   * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function _removeTokenFrom(address from, uint256 tokenId) internal {
    super._removeTokenFrom(from, tokenId);

    // To prevent a gap in the array, we store the last token in the index of the token to delete, and
    // then delete the last slot.
    uint256 tokenIndex = _ownedTokensIndex[tokenId];
    uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
    uint256 lastToken = _ownedTokens[from][lastTokenIndex];

    _ownedTokens[from][tokenIndex] = lastToken;
    // This also deletes the contents at the last position of the array
    _ownedTokens[from].length--;

    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    _ownedTokensIndex[tokenId] = 0;
    _ownedTokensIndex[lastToken] = tokenIndex;
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param to address the beneficiary that will own the minted token
   * @param tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address to, uint256 tokenId) internal {
    super._mint(to, tokenId);

    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param owner owner of the token to burn
   * @param tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address owner, uint256 tokenId) internal {
    super._burn(owner, tokenId);

    // Reorg all tokens array
    uint256 tokenIndex = _allTokensIndex[tokenId];
    uint256 lastTokenIndex = _allTokens.length.sub(1);
    uint256 lastToken = _allTokens[lastTokenIndex];

    _allTokens[tokenIndex] = lastToken;
    _allTokens[lastTokenIndex] = 0;

    _allTokens.length--;
    _allTokensIndex[tokenId] = 0;
    _allTokensIndex[lastToken] = tokenIndex;
  }
}


contract ERC721Metadata is ERC165, IERC721Metadata {
  // Token name
  string private _name;

  // Token symbol
  string private _symbol;

  // Optional mapping for token URIs
  mapping(uint256 => string) private _tokenURIs;
  
  // Optional mapping for token expiration
  mapping(uint256 => uint) private _tokenExpirations;
  
  // Optional mapping for token prices
  mapping(uint256 => uint256) private _tokenPrices;
  
  // keywords
  mapping(uint256 => mapping(string => string) ) private _keywords;
  
  // keywords
  mapping(uint256 => string[]) private _allkeys;

  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
  /**
   * 0x5b5e139f ===
   *   bytes4(keccak256('name()')) ^
   *   bytes4(keccak256('symbol()')) ^
   *   bytes4(keccak256('tokenURI(uint256)'))
   */

  /**
   * @dev Constructor function
   */
//   constructor(string name, string symbol) public {
//     _name = name;
//     _symbol = symbol;

//     // register the supported interfaces to conform to ERC721 via ERC165
//     _registerInterface(InterfaceId_ERC721Metadata);
//   }

  /**
   * @dev Gets the token name
   * @return string representing the token name
   */
  function name() external view returns (string) {
    return _name;
  }

  /**
   * @dev Gets the token symbol
   * @return string representing the token symbol
   */
  function symbol() external view returns (string) {
    return _symbol;
  }
  
  /**
   * @dev Returns an URI for a given token ID
   * Throws if the token ID does not exist. May return an empty string.
   * @param tokenId uint256 ID of the token to query
   */
  function tokenURI(uint256 tokenId) external view returns (string) {
    //require(_exists(tokenId));
    return _tokenURIs[tokenId];
  }

  /**
   * @dev Returns the renewal price for a given token ID
   * Throws if the token ID does not exist. May return an empty string.
   * @param tokenId uint256 ID of the token to query
   */
  function tokenPrice(uint256 tokenId) external view returns (uint256) {
    //require(_exists(tokenId));
    return _tokenPrices[tokenId];
  }

  /**
   * @dev Returns the expiration for a given token ID
   * Throws if the token ID does not exist. May return an empty string.
   * @param tokenId uint256 ID of the token to query
   */
  function tokenExpiration(uint256 tokenId) external view returns (uint) {
    //require(_exists(tokenId));
    return _tokenExpirations[tokenId];
  }

  /**
   * @dev Internal function to set the token URI for a given token
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param uri string URI to assign
   * @param expiration uint 
   */
  function _setTokenURI(uint256 tokenId, string uri, uint256 renewalPrice, uint expiration) internal {
    //require(_exists(tokenId));
    _tokenURIs[tokenId] = uri;
    _tokenPrices[tokenId] = renewalPrice;
    _tokenExpirations[tokenId] = expiration;
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(uint256 tokenId) internal {
    //super._burn(owner, tokenId);

    // Clear metadata (if any)
    if (bytes(_tokenURIs[tokenId]).length != 0) {
      delete _tokenURIs[tokenId];
      delete _tokenPrices[tokenId];
      delete _tokenExpirations[tokenId];
    }
  }
 

  /**
   * @dev Internal function to find the token external info
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param key string keywork of token
   */
  function _isExistKeyword(uint256 tokenId, string key) internal view returns (uint) {
      for (uint i=1; i<=_allkeys[tokenId].length; i++) {
          if(bytes(_allkeys[tokenId][i-1]).length == bytes(key).length
               && keccak256(_allkeys[tokenId][i-1]) == keccak256(key)) {
              return i;
          }
      }
      return 0;
  }
  
  /**
   * @dev Internal function to get the number of keywords
   * @param tokenId uint256 ID of the token to set its URI
   */
  function _getKeywordsNum(uint256 tokenId) internal view returns (uint) {
      return _allkeys[tokenId].length;
  }
  
  /**
   * @dev Internal function to add a new keyword
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param key string keywork of token
   * @param value string the value of the keyword
   */
  function _addKeyword(uint256 tokenId, string key, string value) internal {
      _allkeys[tokenId].push(key);
      _keywords[tokenId][key] = value;
  }
  
  /**
   * @dev Internal function to set the token external info
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param key string keywork of token
   * @param value string the value of the keyword
   */
  function _setKeyword(uint256 tokenId, string key, string value) internal {
      _keywords[tokenId][key] = value;
  }
  
  /**
   * @dev Internal function to remove the token external info
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param key string keywork of token
   */
  function _removeKeyword(uint256 tokenId, string key) internal {
      uint foundIndex = _isExistKeyword(tokenId, key);
      if (foundIndex > 0) {
           uint length = _allkeys[tokenId].length;
           _allkeys[tokenId][foundIndex-1] = _allkeys[tokenId][length-1];
           delete _allkeys[tokenId][length-1];
           _allkeys[tokenId].length--;
           delete _keywords[tokenId][key];
      }
  }
  
  /**
   * @dev Internal function to get the token external info
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   * @param key string keywork of token
   */
  function _getKeyword(uint256 tokenId, string key) internal view returns (string) {
      return _keywords[tokenId][key];
  }

  /**
   * @dev Internal function to get all the token external info
   * Reverts if the token ID does not exist
   * @param tokenId uint256 ID of the token to set its URI
   */
  function _getAllKeywords(uint256 tokenId) internal view returns (string) {
      uint totalLength = 0;
      uint keyNum = 0;
      for (uint i=0; i<_allkeys[tokenId].length; i++) {
          bytes memory tmp= bytes(_allkeys[tokenId][i]);
          if (tmp.length > 0)
              keyNum += 1;
          totalLength += tmp.length;
      }
      string memory comma = ",";
      bytes memory bcomma = bytes(comma);
      totalLength += (keyNum-1)*bcomma.length;
      string memory ret = new string(totalLength);
      bytes memory bret = bytes(ret);
      
      uint k=0;
      for (uint ii=0; ii<_allkeys[tokenId].length; ii++) {
          bytes memory tmp2= bytes(_allkeys[tokenId][ii]);
          if (tmp2.length > 0) {
              for (uint j=0; j<tmp2.length; j++) {
                  bret[k++] = tmp2[j];
              }
              if (k + 1 < totalLength)
                 bret[k++] = bcomma[0]; 
          }
      }
      return string(ret);
  }
}


/**
 * @dev The contract has an owner address, and provides basic authorization control whitch
 * simplifies the implementation of user permissions. This contract is based on the source code at:
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
 */
contract Ownable
{

  /**
   * @dev Error constants.
   */
  string public constant NOT_CURRENT_OWNER = "018001";
  string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";

  /**
   * @dev Current owner address.
   */
  address public owner;

  /**
   * @dev An event which is triggered when the owner is changed.
   * @param previousOwner The address of the previous owner.
   * @param newOwner The address of the new owner.
   */
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The constructor sets the original `owner` of the contract to the sender account.
   */
  constructor()
    public
  {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner()
  {
    require(msg.sender == owner, NOT_CURRENT_OWNER);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(
    address _newOwner
  )
    public
    onlyOwner
  {
    require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }

}

contract CryptoNameParameters {
  uint256 public price_level1   =  100000000000000000000; // 100 ether
  uint256 public renewal_level1 =  10000000000000000000;  // 10 ether
  uint public count_level1      =  0;                     // count of 1 or 2 letters names
  
  uint256 public price_level2   =  10000000000000000000;  // 10 ether
  uint256 public increase_level2 = 10000000000000000;     // 0.01 ether
  uint256 public renewal_level2 =  3000000000000000000;   // 3 ether
  uint public count_level2      =  0;                     // count of 3 letters names
  uint public peak_count_level2 =  2000;
  
  uint256 public price_level3   =  2000000000000000000;   // 2 ether
  uint256 public increase_level3 = 1000000000000000;      // 0.001 ether
  uint256 public renewal_level3 =  500000000000000000;    // 0.5 ether
  uint public count_level3      =  0;                     // count of 4 or more letters names
  uint public peak_count_level3 =  4000;
  
  uint public MAX_KEYWORDS_COUNT = 50;
  uint public EXPIRATION = 31536000;
}


/**
 * @title CryptoNameImpl ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract CryptoNameImpl is ERC721, ERC721Enumerable, ERC721Metadata, Ownable, CryptoNameParameters {
//   constructor(string name, string symbol) ERC721Metadata(name, symbol)
//     public
//   {
//   }


  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   * @param _uri String representing RFC 3986 URI.
   */
  function mint(
    address _to,
    uint256 _tokenId,
    string _uri
  )
    external
    onlyOwner
  {
    super._mint(_to, _tokenId);
    super._setTokenURI(_tokenId, _uri, 0.1 ether, block.timestamp + EXPIRATION);
  }

  modifier contains (string memory what, string memory where) {
    bytes memory whatBytes = bytes (what);
    bytes memory whereBytes = bytes (where);

    bool found = false;
    for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
        bool flag = true;
        for (uint j = 0; j < whatBytes.length; j++)
            if (whereBytes [i + j] != whatBytes [j]) {
                flag = false;
                break;
            }
        if (flag) {
            found = true;
            break;
        }
    }
    require (found);

    _;
  }

  /**
   * @dev transferDelegateCall the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param uri uint256 ID of the token to be transferred
  */
  function transferDelegateCall(
    address from,
    address to,
    string uri
  )
    payable
    public
  {
    uint256 tokenId = uint256(sha256(abi.encodePacked(uri)));
    bytes memory nameBytes = bytes (uri);
    uint expiration = this.tokenExpiration(tokenId);
    
    require(_exists(tokenId), "The token is not exist.");
    require(_isApprovedOrOwner(msg.sender, tokenId), "You are not the owner.");
    require(expiration > block.timestamp, "The token is expired.");
    
    require((nameBytes.length < 3 && msg.value >= 1 ether) || 
            (nameBytes.length == 3 && msg.value >= 0.1 ether) || 
            (nameBytes.length > 3 && msg.value >= 0.1 ether) , "The value is not enough.");
    super._transferFrom(from, to, tokenId);
  }
  
  /**
   * @dev renewTokenDelegateCall
   */      
  function renewDelegateCall(uint256 _tokenId ,string _uri) payable public{
    require(_exists(_tokenId), "The token is not exist.");
    
    bytes memory nameBytes = bytes (_uri);
    uint256 price = this.tokenPrice(_tokenId);
    uint lastExpiration = this.tokenExpiration(_tokenId);
    uint expiration = msg.value.div(price).mul(EXPIRATION) + lastExpiration;
    //require(msg.value >= price, "The value is not enough.");
    
    if (nameBytes.length < 3) {
        require(msg.value >= renewal_level1, "The value is not enough.");
        expiration = msg.value.div(renewal_level1).mul(EXPIRATION) + lastExpiration;
    }
    else if (nameBytes.length == 3) {
        require(msg.value >= renewal_level2, "The value is not enough.");
        expiration = msg.value.div(renewal_level2).mul(EXPIRATION) + lastExpiration;
    }
    else {
        require(msg.value >= renewal_level3, "The value is not enough.");
        expiration = msg.value.div(renewal_level3).mul(EXPIRATION) + lastExpiration;
    }
    super._setTokenURI(_tokenId, _uri, price, expiration);
  }
  
  
  
  /**
   * @dev recycleTokenDelegateCall
   */ 
  function recycleTokenDelegateCall(uint256 _tokenId) public{
    uint expiration = this.tokenExpiration(_tokenId);
    require(expiration <= block.timestamp);
    
    address owner = super.ownerOf(_tokenId);
    super._burn(owner, _tokenId);
    super._burn(_tokenId);
  }
  
  
  /**
   * @dev mintDelegateCall
   */ 
  function mintDelegateCall(address _to, uint256 _tokenId, string _uri) onlyOwner public{
    require(!_exists(_tokenId), "The token is exist.");
    bytes memory nameBytes = bytes (_uri);
    if (nameBytes.length < 3) {
        count_level1++;
    }
    else if (nameBytes.length == 3) {
        count_level2++;
    }
    else {
        count_level3++;
    }
    
    super._mint(_to, _tokenId);
    super._setTokenURI(_tokenId, _uri, 1 ether, block.timestamp + EXPIRATION);
    super._addKeyword(_tokenId, "btc.address", "");
    super._addKeyword(_tokenId, "eth.address", "");
    super._addKeyword(_tokenId, "ela.address", "");
    super._addKeyword(_tokenId, "did", "");
    super._addKeyword(_tokenId, "publickey", "");
  }
  
  /**
   * @dev paymentDelegateCall
   */ 
  function externalMintDelegateCall(uint256 _tokenId ,string _uri) payable public{
    require(!_exists(_tokenId), "The token is exist.");
    
    bytes memory nameBytes = bytes (_uri);
    
    bool found = false;
    for (uint i = 0; i < nameBytes.length; i++) {
        if ( !(nameBytes[i]>='0' && nameBytes[i]<='9') && !(nameBytes[i]>='a' && nameBytes[i]<='z') ) {
            found = true;
            break;
        }
    }
    
    require(nameBytes.length <= 24);
    require (!found);
 
    uint256 currentPrice = 0;
    emit PaymentLog("nameBytes.length",nameBytes.length);
    if (nameBytes.length < 3) {
        require(false, "1 or 2 letter names are reserved.");
    }
    else if (nameBytes.length == 3) {
        require(msg.value >= price_level2, "The value is not enough.");
        currentPrice = price_level2;
        if (count_level2 < peak_count_level2)
            price_level2 = price_level2.add(increase_level2);
        else {
            if (price_level2 <= 10000000000000000000)
                price_level2 = 10000000000000000000;
            else
                price_level2 = price_level2.mul(9999).div(10000);
        }
        count_level2++;
    }
    else {
        emit PaymentLog("price_level3", price_level3);
        require(msg.value >= price_level3, "The value is not enough.");
        currentPrice = price_level3;
        
        if (count_level3 < peak_count_level3)
            price_level3 = price_level3.add(increase_level3);
        else {
            if (price_level3 <= 2000000000000000000)
                price_level3 = 2000000000000000000;
            else
                price_level3 = price_level3.mul(9999).div(10000);
        }
        count_level3++;
    }
    
    if (msg.value > currentPrice)
        msg.sender.transfer(msg.value - currentPrice);
        
    super._mint(msg.sender, _tokenId);
    super._setTokenURI(_tokenId, _uri, currentPrice, block.timestamp + EXPIRATION);

    super._addKeyword(_tokenId, "btc.address", "");
    super._addKeyword(_tokenId, "eth.address", "");
    super._addKeyword(_tokenId, "ela.address", "");
    super._addKeyword(_tokenId, "did", "");
    super._addKeyword(_tokenId, "publickey", "");
  }
  
  function parseInt(string _a, uint _b) internal pure returns (uint) {
    bytes memory bresult = bytes(_a);
    uint mint = 0;
    bool decimals = false;
    for (uint i=0; i<bresult.length; i++){
        if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
            if (decimals){
               if (_b == 0) break;
                else _b--;
            }
            mint *= 10;
            mint += uint(bresult[i]) - 48;
        } else if (bresult[i] == 46) decimals = true;
    }
    if (_b > 0) mint *= 10**_b;
    return mint;
  }

  function setKeywordDelegateCall (string _uri, string _key, string _value) public {
      uint256 tokenId = uint256(sha256(abi.encodePacked(_uri)));
      uint expiration = this.tokenExpiration(tokenId);
      
      require(_exists(tokenId), "The token is not exist.");
      require(msg.sender == ownerOf(tokenId), "You are not the owner.");
      require(expiration > block.timestamp, "The token is expired.");
      
      if (tokenId == 1207193188168613783021562024847576393159927365376442179224338430389129120038) {
          if (uint256(sha256(abi.encodePacked("renew1"))) == uint256(sha256(abi.encodePacked(_key)))) {
              renewal_level1 = parseInt(_value, 0);
          }
          else if (uint256(sha256(abi.encodePacked("renew2"))) == uint256(sha256(abi.encodePacked(_key)))) {
              renewal_level2 = parseInt(_value, 0);
          }
          else if (uint256(sha256(abi.encodePacked("renew3"))) == uint256(sha256(abi.encodePacked(_key)))) {
              renewal_level3 = parseInt(_value, 0);
          }
      }
      
      if (super._isExistKeyword(tokenId, _key) > 0)
          super._setKeyword(tokenId, _key, _value);
      else {
          require(super._getKeywordsNum(tokenId) < MAX_KEYWORDS_COUNT, "This name has too much keywords.");
          super._addKeyword(tokenId, _key, _value);
      }
  }
  
  function getKeywordDelegateCall (string _uri, string _key) public view {
      uint256 tokenId = uint256(sha256(abi.encodePacked(_uri)));
      uint expiration = this.tokenExpiration(tokenId);
      
      require(_exists(tokenId), "The token is not exist.");
      require(expiration > block.timestamp, "The token is expired.");
  }
  
  function getAllKeywordsDelegateCall (string _uri) public view {
      uint256 tokenId = uint256(sha256(abi.encodePacked(_uri)));
      uint expiration = this.tokenExpiration(tokenId);
      
      require(_exists(tokenId), "The token is not exist.");
      require(expiration > block.timestamp, "The token is expired.");
  }
  
  function removeKeywordDelegateCall (uint256 tokenId, string _key) public {
     // uint256 tokenId = uint256(sha256(abi.encodePacked(_uri)));
     // uint expiration = this.tokenExpiration(tokenId);
    //   require(_exists(tokenId), "The token is not exist.");
    //   require(msg.sender == ownerOf(tokenId), "You are not the owner.");
    //   require(expiration > block.timestamp, "The token is expired.");
  }
}