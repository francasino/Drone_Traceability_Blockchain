pragma solidity ^0.4.24;

contract Drone_logistics{

	//MODEL  a candidate
	struct Product {
		uint id;
		string name;
		uint quantity;
		string others;  // for QOs or conditions, location etc
	}
	// key is a uint, later corresponding to the product id
	// what we store (the value) is a Product
	// the information of this mapping is the set of products of the order.
	mapping(uint => Product) private products; // public, so that w can access with a free function 

	struct Traces {
		uint id:
		string location;
		string temp_owner;
	}

	mapping(uint => Traces) private traces; // public, so that w can access with a free function 
	//store products count
	// since mappings cant be looped and is difficult the have a count like array
	// we need a var to store the coutings  
	// useful also to iterate the mapping 
	uint private productsCount;
	uint private tracesCount;

	//declare address of the participants
	address constant public customer = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
	address constant public manager = 0xE0f5206BBD039e7b0592d8918820024e2a743445;
	address constant public deliverer = 0xE0f5206BBD039e7b0592d8918820024e2a743222;

	private bool triggered;
	private bool delivery;
	private bool received;


	// event, voted event. this will trigger when we want
	//  when a vote is cast for example, in the vote function. 
	event triggeredEvent (  // triggers new accepted order 
	);

	event deliveryEvent (  // triggers delivery start
	);

	event receivedEvent ( // triggers order received by customer
	);

	event updateEvent ( // triggers product status change
	);


	function Drone_logistics () public { // constructor, creates order. we map starting from id=1
	 addProduct(1,"Example",200, "Delivey in 3 days, temperature X");
	 addTrace("some coordinates", "name or address of actual owner")
	 triggered=false;
	 delivery=false;
	 received=false;
	}

    // add product to mapping.   private because we dont want to be accesible or add products afterwards to our mapping. We only want
    // our contract to be able to do that, from constructor
    // otherwise the conditions of the accepted contract could change
    function addProduct (string _name, uint _quantity, string _others) private {
    	productsCount ++; // inc count at the begining. represents ID also. 
    	products[productsCount] = Product(productsCount, _name,_quantity,_others);
    	// reference the mapping with the key (that is the count). We assign the value to 
    	// the mapping, the count will be the ID.  
    }

    // returns the number of products, needed to iterate the mapping and to know info about the order.
    // all 
    function getNumberOfProducts () returns (uint){
    	require(msg.sender==customer || msg.sender==manager || msg.sender==deliverer);
    	return productsCount;
    }

    // returns the number of traced locations
    //all
    function getNumberOfTracess () returns (uint){
    	require(msg.sender==customer || msg.sender==manager || msg.sender==deliverer);
    	return tracesCount;
    }

    // function to check the contents of the contract, the customer will check it and later will trigger if correct
    // only customer can check it 
    // customer will loop outside for this, getting the number of products before with getNumberOfProducts
    function getOrder (uint _productId) returns (Product) {
    	require(msg.sender==customer);

    	require(_productId > 0 && _productId <= productsCount); 

    	return products[_productId];
    }



    // get all locations
    function getOrder (uint _traceId) returns (Trace) {
    	require(msg.sender==customer || msg.sender==deliverer);

    	require(_traceId > 0 && _traceId <= tracesCount); 

    	return traces[_traceId];
    }

    //this function triggers the contract, enables it since the customer accepts it 
    // only customer
    function triggerContract () public { 
    	require(msg.sender==customer);
		triggered=true;
		emit triggeredEvent(); // trigger event 

    }

    // only manager
    function deliverOrder () public { 
    	require(msg.sender==manager);
		delivery=true;
		emit deliveryEvent(); // trigger event 

    }

    //only customer
    function receivedOrder () public { 
    	require(msg.sender==customer);
		received=true;
		emit receivedEvent(); // trigger event 

    }

    // only manager or deliverers
    function UpdateProduct (uint _productId, string _others) public { 
    	require(msg.sender==manager || msg.sender==deliverer);
		products[_productId].others = _others;  // update conditions
		emit updateEvent(); // trigger event 
    }

    function addTrace (string _location, string _temp_owner) public {  // acts as update location
    	require(msg.sender==manager || msg.sender==deliverer);
    	tracesCount ++; // inc count at the begining. represents ID also. 
    	traces[tracesCount] = Product(tracesCount, _location,_temp_owner);
    	emit updateEvent();
    	// reference the mapping with the key (that is the count). We assign the value to 
    	// the mapping, the count will be the ID.  
    }


}
