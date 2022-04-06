pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

   

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

     event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

   constructor() public {
        name = "Example Marketplace";
    }

   


    //CREATE PRODUCT
   function createProduct(string memory _name, uint _price) public {
       //Require valid name
       require(bytes(_name).length > 0);
       // require valid price
       require (_price > 0);
       // Increment the product count
       productCount ++;
       //Create product
       products[productCount] = Product(productCount, _name, _price, msg.sender, false);
       //trigger event to notify listeners that a product was created on the blockchain
       emit ProductCreated(productCount, _name, _price, msg.sender, false);
   } 

   //PURCHASE A PRODUCT
   function purchaseProduct(uint _id) public payable {
       // Grab the product
       Product memory _product = products[_id];
       // Grab the owner
       address payable _seller = _product.owner;
       // Validate that the product has a valid ID
       require(_product.id > 0 && _product.id <= productCount);
       // Require that there is enough ether in the transaction
       require(msg.value >= _product.price);
       // Require the product has not been purchased already
       require(!_product.purchased);
       // Require that the buyer cannot be the seller
       require(_seller != msg.sender);
       // Transfer ownership to buyer
       _product.owner = msg.sender;
       // Mark as purchased
       _product.purchased = true;
       // Update the product
       products[_id] = _product;
       // Pay the seller by sending them ether
       address(_seller).transfer(msg.value);
       // Trigger an event to notify listeners that a purchase was made
       emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true); 
   }




}