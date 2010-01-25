--
-- Tests.hs
--

module Main where
import Test.HUnit
import $main


main = runTestTT $
       TestList [failingTest]

failingTest =
    TestList[1 ~?= 2]
