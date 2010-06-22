(ns xxxx-test
    (:use clojure.test xxxx :reload-all))

(deftest failure
    (is (= 0 1)))

