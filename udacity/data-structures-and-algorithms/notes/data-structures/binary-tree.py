#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 14:21:38 2019

@author: mrodgers
"""

## your code here
class Node:
    
    def __init__(self, value=None):
        self.value = value
        self.left = None
        self.right = None
    
    def get_value(self):
        return self.value
    
    def set_value(self, value):
        self.value = value
        
    def set_left_child(self, node):
        self.left = node
    
    def set_right_child(self, node):
        self.right = node
    
    def get_left_child(self):
        return self.left
    
    def get_right_child(self):
        return self.right
    
    def has_left_child(self):
        return self.left != None
    
    def has_right_child(self):
        return self.right != None
    
# define a Tree class here
class Tree:
    
    def __init__(self, node):
        self.root = node
    
    def get_root(self):
        return self.root