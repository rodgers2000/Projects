#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 28 14:09:00 2019

@author: mrodgers
"""

def get_min_max(ints):
    """
    Return a tuple(min, max) out of list of unsorted integers.

    Args:
       ints(list): list of integers containing one or more integers
    """
    
    min0 = ints[0]
    max0 = ints[0]
    for number in ints:
        if number < min0:
            min0 = number
        if number > max0:
            max0 = number
    return (min0, max0)

## Example Test Case of Ten Integers
import random

l = [i for i in range(0, 10)]  # a list containing 0 - 9
random.shuffle(l)

print ("Pass" if ((0, 9) == get_min_max(l)) else "Fail")

print(get_min_max([-1, 0, 1]))
print(get_min_max([1, 0, -1]))
print(get_min_max([0, 0, 0]))