#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 14:30:28 2019

@author: mrodgers
"""

def dfs_search(root_node, search_value):
    visited = []
    stack = [root_node]
    
    while len(stack) > 0:
        current_node = stack.pop()
        visited.append(current_node)

        if current_node.value == search_value:
            return current_node

        for child in current_node.children:
            if child not in visited:
                stack.append(child)
                
def dfs_recursion_start(self, start_node):
    visited = {}
    self.dfs_recursion(start_node, visited)

def dfs_recursion(self, node,visited):
    
    if(node == None):
        return False
    
    visited[node.value] = True
    print(node.value)
    
    for each in node.children:
        if( each.value not in visited ):
            self.dfs_recursion(each,visited)