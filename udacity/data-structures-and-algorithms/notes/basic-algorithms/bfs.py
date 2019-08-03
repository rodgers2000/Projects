#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 14:31:55 2019

@author: mrodgers
"""

def bfs_search(root_node, search_value):
    visited = []
    queue = [root_node]
    
    while len(queue) > 0:
        current_node = queue.pop(0)
        visited.append(current_node)

        if current_node.value == search_value:
            return current_node

        for child in current_node.children:
            if child not in visited:
                queue.append(child)