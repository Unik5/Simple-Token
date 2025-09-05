// The 'test_token_intern_Unique_Lama' test program.
import token_intern_unique_lama.aleo;
program test_token_intern_unique_lama.aleo {


    /*  Private  */
    //Private Token Minting

    @test 
    transition test_mint_private(){
        let sender_Token : token_intern_unique_lama.aleo/Token = token_intern_unique_lama.aleo/mint_private(aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h,10u64);
        let receiver_Token: token_intern_unique_lama.aleo/Token = token_intern_unique_lama.aleo/mint_private(aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh,0u64);
        // Testing Sender Token Minting
        assert_eq(sender_Token.owner, aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h );
        assert_eq(sender_Token.amount,10u64 );
        //Testing Receiver Token Minting
        assert_eq(receiver_Token.owner,aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh );
        assert_eq(receiver_Token.amount,0u64 );
        
    }

    //Transfer Private Tests

    //test if sender has less amount than what is being sent
    @test 
    @should_fail
    transition test_transfer_private_revert(){
        let sender_Token :token_intern_unique_lama.aleo/Token  = token_intern_unique_lama.aleo/mint_private(aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h,10u64);
        let receiver_Token: token_intern_unique_lama.aleo/Token = token_intern_unique_lama.aleo/mint_private(aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh,0u64);
        let (remaining,transferred) = token_intern_unique_lama.aleo/transfer_private(sender_Token,receiver_Token.owner,20u64);
    }

    //test if the generated Tokens are valid or not
    @test
    transition test_transfer_private(){
        let sender_Token :token_intern_unique_lama.aleo/Token  = token_intern_unique_lama.aleo/mint_private(self.caller,10u64); //self.caller because the owner of a token can only consume the token, as the one signinig now is this test contract
        let receiver_Token: token_intern_unique_lama.aleo/Token = token_intern_unique_lama.aleo/mint_private(aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh,0u64);
        let (remaining,transferred) = token_intern_unique_lama.aleo/transfer_private(sender_Token,receiver_Token.owner,5u64);
        //Checking for sender
        assert_eq(sender_Token.owner,remaining.owner );
        assert_eq(remaining.amount,5u64);
        //Checking for Receiver
        assert_eq(receiver_Token.owner,transferred.owner );
        assert_eq(transferred.amount,5u64 );
    }

    /*  Public  */

    //Testing mint_public
    @test
    script test_mint_public(){
        const mint_value:u64 = 10u64;
        const mint_address:address= aleo1rcd58pzwu2scq8rs8l7zs4nryqyu75rhypayywg5zxduqk0tagzsk5dfcm;
        let (minted_Token,fut) = token_intern_unique_lama.aleo/mint_public(mint_address,mint_value);
        fut.await();
        let balance:u64=Mapping::get(token_intern_unique_lama.aleo/account,mint_address);
        assert_eq(mint_value,balance); //
        assert_eq(minted_Token.amount,balance ); //Test if the public token matches the data upadted by finalize function in onchain mapping
    }

    //Tests for Transfer Public 
    //Testing transfer_public reverts if sender has less amount than what is being sent
    @test
    @should_fail
    script test_transfer_public_revert(){
        let receiver:address = aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h;
        let sender_Token :token_intern_unique_lama.aleo/Token  = token_intern_unique_lama.aleo/mint_private(aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh,10u64);
        let (new_sender_Token,new_receiver_Token,fut)=token_intern_unique_lama.aleo/transfer_public(sender_Token,receiver,20u64);
    }


    //testing transfer_public functionality
    @test
    script test_transfer_public(){
        let receiver:address = aleo1pdcs5vhxql6qhj28xpgq3fp75sgyg6k68mufqdgzhercm6wm7sqqamvv59;
        let (sender_Token,futu) = token_intern_unique_lama.aleo/mint_public(self.caller,20u64);
        futu.await();
        let (new_sender_Token,new_receiver_Token,fut)=token_intern_unique_lama.aleo/transfer_public(sender_Token,receiver,5u64);
        fut.await();
        let sender_balance:u64= Mapping::get(token_intern_unique_lama.aleo/account,sender_Token.owner);
        let receiver_balance:u64=Mapping::get(token_intern_unique_lama.aleo/account,receiver);
        assert_eq(sender_balance,15u64);
        assert_eq(receiver_balance,5u64);
    }
    
    @noupgrade
    async constructor() {}
}
