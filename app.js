var web3 = new Web3()

if(window.web3.currentProvider == null){
	web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'))
}

// var home_insurance_byte_code = '606060405260056000600050556005600160005055600160026000505560016003600050555b5b610196806100346000396000f36060604052361561003d576000357c0100000000000000000000000000000000000000000000000000000000900480633bdcab5b146101095761003d565b6101075b600060003391503490506003600050548110156100615761010356610102565b60011515600460005060008473ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16151514156100ac57610103565b6001600460005060008473ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff021916908302179055508060056000828282505401925050819055505b5b5050565b005b610116600480505061012e565b60405180821515815260200191505060405180910390f35b6000600033905060011515600460005060008373ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff1615151415610188576001915061019256610191565b60009150610192565b5b509056'
//
// var home_insurance_abi = [{"constant":true,"inputs":[],"name":"amIMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"}]
//
// var contractAddress = '0xbc5e1426d14c60fbcd7b7956aa9dba97e77cd56f';

var txtObj = function(){
  return {
	  from: web3.eth.accounts[0],
	  gas: 3000000
	}
}

var txtObjWithContractCode = function(code){
	var returnObj = txtObj()
	returnObj.data = code
	return returnObj
}

var get_balance_of_contract = function(contract_address){
	console.log('con', contract_address);
  var balance = web3.eth.getBalance(contract_address)
	return balance
}

var homeinsuranceContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"amIMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"input","type":"address"}],"name":"isMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"}]);

var new_home_insurance_contract = function(){
	var homeinsuranceContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"amIMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"input","type":"address"}],"name":"isMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"}]);
	var homeinsurance = homeinsuranceContract.new(
	   {
	     from: web3.eth.accounts[0],
	     data: '606060405260056000600050556005600160005055600160026000505560016003600050555b5b610233806100346000396000f360606040523615610048576000357c0100000000000000000000000000000000000000000000000000000000900480633bdcab5b14610114578063a230c5241461013957610048565b6101125b6000600033915034905060036000505481101561006c5761010e5661010d565b60011515600460005060008473ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16151514156100b75761010e565b6001600460005060008473ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff021916908302179055508060056000828282505401925050819055505b5b5050565b005b6101216004805050610167565b60405180821515815260200191505060405180910390f35b61014f60048080359060200190919050506101cf565b60405180821515815260200191505060405180910390f35b6000600033905060011515600460005060008373ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16151514156101c157600191506101cb566101ca565b600091506101cb565b5b5090565b600060011515600460005060008473ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff1615151415610224576001905061022e5661022d565b6000905061022e565b5b91905056',
	     gas: 3000000
	   }, function(e, contract){
	    console.log(e, contract);
	    if (typeof contract.address != 'undefined') {
	         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
	    }
	 })
 }

click_balance_button = function(){
	var address = document.getElementById('contract_address').value
	console.log(address);
	var balance = get_balance_of_contract(address)
	console.log(balance.toString(10));
	document.getElementById('contract_balance').value = balance.toString(10);

}

var c_address = '0xd20a6469d44a48758e8e2b3ae600da856468201b';

var send_ether = function(sender, receiver, amount){
	var txObj = {from: sender, to: receiver, value: amount}
	web3.eth.sendTransaction(txObj, function(err, address){
		if(!err){
			console.log(address)
		}
	})
}

var homeinsuranceInstance = homeinsuranceContract.at(c_address);
console.log(homeinsuranceInstance.amIMember());
