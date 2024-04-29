
//const prompt = require("prompt-sync")();
require("dotenv").config();
const TronWeb = require('tronweb');

const fullNode = 'https://api.shasta.trongrid.io';
const solidityNode = 'https://api.shasta.trongrid.io';
const eventServer = 'https://api.shasta.trongrid.io';
const privateKey = process.env.PRIVATE_KEY_SHASTA;
const tronWeb = new TronWeb(fullNode, solidityNode, eventServer, privateKey);


async function voteBooksCall(bookIds, classification) {
    contractAddress = "TFBP2xBhYTb2hNrLep5UpFW1a2DZ5AP4yY";
    let contract = await tronWeb.contract().at(contractAddress);
    let transactionID = await contract.voteBooks(bookIds, classification).send();
    console.log(`TransactionID: ${transactionID}`);
}

try {
    voteBooksCall([32], [5])
}
catch (error) {
    console.error(error);
    //throw e
}

