(ns xxxx-test
    (:use clojure.test)
    (:use midje.sweet)
    (:use xxxx :reload-all))

(deftest failure
    (is (= 0 1)))

