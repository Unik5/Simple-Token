// import credits.aleo;
program token_intern_unique_lama.aleo {
    // for upgrade
    @noupgrade
    async constructor() {}

    // On-chain storage of an `account` map, with `address` as the key,
    // and `u64` as the value.
    mapping account: address => u64; //public
    //Private
    record Token {
    // The token owner.
        owner: address,
    // The token amount.
        amount: u64,
    }

    /* Mint */
    // The function `mint_public` issues the specified token amount for the token receiver publicly on the network.
    async transition mint_public(public receiver: address, public amount: u64) -> (Token,Future) {
        let mint:Token= Token {
            owner:receiver,
            amount:amount,
        };
        // Mint the tokens publicly by invoking the computation on-chain.
        return (mint,finalize_mint_public(receiver, amount));
    }
    async function finalize_mint_public(public receiver: address, public amount: u64) {
        // Increments `account[receiver]` by `amount`.
        // If `account[receiver]` does not exist, it will be created.
        // If `account[receiver] + amount` overflows, `mint_public` is reverted.
        let current_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, current_amount + amount);
    }
    
    // The function `mint_private` initializes a new record with the specified amount of tokens for the receiver.
    transition mint_private(receiver: address, amount: u64) -> Token {
        return Token {
        owner: receiver,
        amount: amount,
        };
    }

    // The function `transfer_private` sends the specified token amount to the token receiver from the specified token record.
    transition transfer_private(sender: Token, receiver: address, amount: u64) -> (Token, Token) {
        // Checks the given token record has sufficient balance.
        assert(sender.amount > amount);
        // `difference` holds the change amount to be returned to sender.
        let difference: u64 = sender.amount - amount;
        // Produce a token record with the change amount for the sender.
        let remaining: Token = Token {
            owner: sender.owner,
            amount: difference,
        };
        // Produce a token record for the specified receiver.
        let transferred: Token = Token {
            owner: receiver,
            amount: amount,
        };
        // Output the sender's change record and the receiver's record.
        return (remaining, transferred);
    }

    // The function transfer_public sends token amount to receiver from sender publicly using credits.aleo
    //async as it need to write in blockchain
    // async transition transfer_public(sender:address, receiver:address, amount: u64)-> Future{
    //     return credits.aleo/transfer_public(sender,receiver,amount);
    // }


    // transfer_public function manually
    // this transition generates new records for both the sender and the receiver.
    async transition transfer_public(public sender:Token, public receiver:address,public amount:u64)->(Token,Token,Future){
        assert(sender.amount>amount); // check if the sender has enough amount 
        // new sender record
        let new_sender_Token:Token = Token{
            owner:sender.owner,
            amount:sender.amount - amount,
        };
        // new receiver record
        let new_receiver_Token:Token = Token{
            owner:receiver,
            amount:amount,
        };
        return (new_sender_Token,new_receiver_Token,finalize_transfer_public(new_sender_Token.owner,receiver,amount)); // returns the new record and a future
    }

    // Future that updates the balances for the sender and receiver on the blockchain.
    async function finalize_transfer_public(public sender:address,public receiver:address,public amount:u64){
        let sender_balance = Mapping::get_or_use(account,sender,0u64); //obtain senders balance from the mapping(blockchain)
        assert(sender_balance>amount); // check if the sender has enough balance
        let receiver_balance = Mapping::get_or_use(account,receiver,0u64); // obtain receivers balance , if not found then create a mapping with 0 balance
        // update the new balance
        Mapping::set(account,sender,sender_balance-amount); 
        Mapping::set(account,receiver,receiver_balance+amount);
    }
}