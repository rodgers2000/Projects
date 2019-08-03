#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 27 13:28:43 2019

@author: mrodgers
"""

def sqrt(number):
    """
    Calculate the floored square root of a number

    Args:
       number(int): Number to find the floored squared root
    Returns:
       int: Floored Square Root
    """
    
    if number == None:
        return "None number dfoes not have a square root"
    
    if number < 0:
        return "Negative number does not have a square root"
    
    if number == 0:
        return 0
    if number == 1:
        return 1
    x0 = number
    x1 = (number) // 2 # first guess
    while x1 != x0:
        x0 = x1 
        x1 = (x0 + number // x0) // 2 # second guess
    return x1

print ("Pass" if  (3 == sqrt(9)) else "Fail")
print ("Pass" if  (0 == sqrt(0)) else "Fail")
print ("Pass" if  (4 == sqrt(16)) else "Fail")
print ("Pass" if  (1 == sqrt(1)) else "Fail")
print ("Pass" if  (5 == sqrt(27)) else "Fail")

print(sqrt(None))
# None
print(sqrt(-9))