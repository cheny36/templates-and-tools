#!/usr/bin/env python3

"""
@author Yi Chen
@date
"""

import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""Description""")
    parser.add_argument("-v", "--val", type=int, default=1, metavar="n", help="value")
    params = parser.parse_args()
