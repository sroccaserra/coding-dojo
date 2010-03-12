-module(test_ut).
-compile(export_all).
-import($main, []).

failing_test() ->
    true = false.
