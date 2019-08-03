#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 14:16:49 2019

@author: mrodgers
"""

class Stack:
    def __init__(self):
         # TODO: Initialize the Stack
        self.items = []
    
    def size(self):
         # TODO: Check the size of the Stack
        return len(self.items)
    
    def push(self, item):
         # TODO: Push item onto Stack
        self.items.append(item)

    def pop(self):
         # TODO: Pop item off of the Stack
        return self.items.pop()