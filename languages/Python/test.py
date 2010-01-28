#
# test.py
#

import unittest
from $main import *

class Tests(unittest.TestCase):
    def testFailure(self):
        self.assertEqual(1, 2)
