#
# test.py
#

import unittest
from $main import *

class Tests(unittest.TestCase):
    def testFails(self):
        assert(False)

if __name__ == '__main__':
    unittest.main()
