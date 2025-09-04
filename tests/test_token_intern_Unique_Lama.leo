// The 'test_token_intern_Unique_Lama' test program.
import token_intern_Unique_Lama.aleo;
program test_token_intern_Unique_Lama.aleo {
    @test
    script test_it() {
        let result: u32 = token_intern_Unique_Lama.aleo/main(1u32, 2u32);
        assert_eq(result, 3u32);
    }

    @test
    @should_fail
    transition do_nothing() {
        let result: u32 = token_intern_Unique_Lama.aleo/main(2u32, 3u32);
        assert_eq(result, 3u32);
    }

    @noupgrade
    async constructor() {}
}
