let prelude = import "std/prelude.hs"
let { run, monad, assert_eq, assert_seq, assert_ieq } = import "std/test.hs"
let { Ord, Num, List, Option, Monoid } = prelude
let { (<) } = prelude.make_Ord prelude.ord_Int
let { (+) } = prelude.num_Int
let { (>>=), return, (>>), join, map, lift2, forM_ }
        = prelude.make_Monad monad

let string = import "std/string.hs"

let assert_oieq = assert_eq (prelude.show_Option prelude.show_Int) (prelude.eq_Option prelude.eq_Int)

let slice_tests =
    assert_seq (string.slice "ab" 0 1) "a" >>
        assert_seq (string.slice "ab" 1 2) "b" >>
        assert_seq (string.slice "abcd" 2 4) "cd"

let append_tests =
    let { (<>) } = string.monoid
    assert_seq ("ab" <> "cd") "abcd" >>
        assert_seq ("ab" <> "") "ab" >>
        assert_seq ("" <> "cd") "cd" >>
        assert_seq ("" <> "") ""

let find_tests =
    assert_oieq (string.find "abcd1234" "ab") (Some 0) >>
        assert_oieq (string.find "abcd1234" "b") (Some 1) >> 
        assert_oieq (string.find "abcd1234" "4") (Some 7) >>
        assert_oieq (string.find "abcd1234" "xyz") None >>
        assert_oieq (string.rfind "abcdabcd" "b") (Some 5) >> 
        assert_oieq (string.rfind "abcdabcd" "d") (Some 7) >> 
        assert_oieq (string.rfind "abcd1234" "xyz") None

let tests =
    slice_tests >> append_tests >> find_tests

run tests