#
# xxxx_test.py
#

""" Doctests can be written in the main file, unittest can be written here.

More info here: http://docs.python.org/library/doctest.html
And here: http://docs.python.org/library/unittest.html

"""

import unittest
from xxxx import *

class Tests(unittest.TestCase):
    def testFailure(self):
        self.assertEqual(1, 2)
