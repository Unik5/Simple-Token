import token_intern_unique_lama.aleo;
program test_token_intern_unique_lama.aleo;

function test_mint_private:
    call token_intern_unique_lama.aleo/mint_private aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h 10u64 into r0;
    call token_intern_unique_lama.aleo/mint_private aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh 0u64 into r1;
    assert.eq r0.owner aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h;
    assert.eq r0.amount 10u64;
    assert.eq r1.owner aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh;
    assert.eq r1.amount 0u64;

function test_transfer_private_revert:
    call token_intern_unique_lama.aleo/mint_private aleo1kht7kx6y25l3vjly9su54h5l5vmp6pe2d7r52tvdczzget3fruqqmqsf4h 10u64 into r0;
    call token_intern_unique_lama.aleo/mint_private aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh 0u64 into r1;
    call token_intern_unique_lama.aleo/transfer_private r0 r1.owner 20u64 into r2 r3;

function test_transfer_private:
    call token_intern_unique_lama.aleo/mint_private self.caller 10u64 into r0;
    call token_intern_unique_lama.aleo/mint_private aleo1gx3ljz067etzhf7f4pr4se7y8kgpyk04skme2e7mred2z9sn0gzshpg6wh 0u64 into r1;
    call token_intern_unique_lama.aleo/transfer_private r0 r1.owner 5u64 into r2 r3;
    assert.eq r0.owner r2.owner;
    assert.eq r2.amount 5u64;
    assert.eq r1.owner r3.owner;
    assert.eq r3.amount 5u64;

constructor:
    assert.eq edition 0u16;
