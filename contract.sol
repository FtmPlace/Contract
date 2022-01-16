/**
 *Submitted for verification at FtmScan.com on 2021-05-31
*/

pragma solidity ^0.8.0;
 
contract FTMPlace {
  struct Pixel {
    address owner;
    uint soldPrice;
    bytes3 color;
  }
  
    Pixel[1000][1000] public pixels;
  
  event PixelChanged(
    uint x,
    uint y,
    address owner,
    uint soldPrice,
    bytes3 color
  );
  
  uint public basePrice = 40000000 gwei;
  
  uint public NumberPixelChanged = 0;
  
  function colorPixel(uint x, uint y, bytes3 color) public payable {
    Pixel storage pixel = pixels[x][y];
    uint256 newPrice = msg.value;
    uint256 lastPrice = pixel.soldPrice;
    address lastOwner = pixel.owner;
 
    require(newPrice >= lastPrice  + pixel.soldPrice / 5);
 
    if (pixel.owner != address(0x0)) {
        pixel.owner = msg.sender;
        pixel.soldPrice = newPrice;
        pixel.color = color;
        payable(lastOwner).transfer(lastPrice + lastPrice / 10);
        
    } else {
        require(newPrice >= basePrice);
        pixel.owner = msg.sender;
        pixel.soldPrice = basePrice;
        pixel.color = color;
    }
 
    emit PixelChanged(x, y, pixel.owner, pixel.soldPrice, pixel.color);
    NumberPixelChanged++;
  }
  
  function colorMultiplePixel(uint[] memory x, uint[] memory y, bytes3[] memory color) public payable {
    uint finalprice = 0; 
    for (uint i = 0; i<x.length; i++ ) {
        uint xi = x[i];
        uint yi = y[i];
        bytes3 colori = color[i];
        Pixel storage pixel = pixels[xi][yi];
        uint256 newPrice = pixel.soldPrice + pixel.soldPrice / 5;
        uint256 lastPrice = pixel.soldPrice;
        address lastOwner = pixel.owner;
        
        
     
        if (pixel.owner != address(0x0)) {
            pixel.owner = msg.sender;
            pixel.soldPrice = newPrice;
            pixel.color = colori;
            payable(lastOwner).transfer(lastPrice + lastPrice / 10);
            finalprice = finalprice + newPrice; 
            
        } else {
            pixel.owner = msg.sender;
            pixel.soldPrice = basePrice;
            finalprice = finalprice + basePrice; 
            pixel.color = colori;
        }
     
        emit PixelChanged(xi, yi, pixel.owner, pixel.soldPrice, pixel.color);
        NumberPixelChanged++;
        
    }
    if(msg.value < finalprice) {
        revert();
    }
    
  }
  
  function getBalance() public view returns(uint) {
        return address(this).balance;
    }
  
  function withdraw(uint amount) public returns(bool) {
        address payable owner = payable(0x170573117343922cc767913e4421C107E428161b);
        require(msg.sender == owner);
        owner.transfer(amount);
        return true;
    }
}
 
// SPDX-License-Identifier: UNLICENSED
