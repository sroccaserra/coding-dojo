(ns test
    (:use clojure.test $main))

(deftest failure
    (is (= 0 1)))

