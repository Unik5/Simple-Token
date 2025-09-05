program token_intern_unique_lama.aleo;

record Token:
    owner as address.private;
    amount as u64.private;

mapping account:
    key as address.public;
    value as u64.public;

function mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    cast r0 r1 into r2 as Token.record;
    async mint_public r0 r1 into r3;
    output r2 as Token.record;
    output r3 as token_intern_unique_lama.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];

function mint_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as Token.record;
    output r2 as Token.record;

function transfer_private:
    input r0 as Token.record;
    input r1 as address.private;
    input r2 as u64.private;
    gt r0.amount r2 into r3;
    assert.eq r3 true;
    sub r0.amount r2 into r4;
    cast r0.owner r4 into r5 as Token.record;
    cast r1 r2 into r6 as Token.record;
    output r5 as Token.record;
    output r6 as Token.record;

function transfer_public:
    input r0 as Token.record;
    input r1 as address.public;
    input r2 as u64.public;
    gt r0.amount r2 into r3;
    assert.eq r3 true;
    sub r0.amount r2 into r4;
    cast r0.owner r4 into r5 as Token.record;
    cast r1 r2 into r6 as Token.record;
    async transfer_public r5.owner r1 r2 into r7;
    output r5 as Token.record;
    output r6 as Token.record;
    output r7 as token_intern_unique_lama.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get.or_use account[r0] 0u64 into r3;
    gt r3 r2 into r4;
    assert.eq r4 true;
    get.or_use account[r1] 0u64 into r5;
    sub r3 r2 into r6;
    set r6 into account[r0];
    add r5 r2 into r7;
    set r7 into account[r1];

constructor:
    assert.eq edition 0u16;
