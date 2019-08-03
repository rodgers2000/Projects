#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 19:58:34 2019

@author: mrodgers
"""

class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

    def __repr__(self):
        return str(self.value)

class LinkedList:
    def __init__(self):
        self.head = None

    def __str__(self):
        cur_head = self.head
        out_string = ""
        while cur_head:
            out_string += str(cur_head.value) + " -> "
            cur_head = cur_head.next
        return out_string


    def append(self, value):

        if self.head is None:
            self.head = Node(value)
            return

        node = self.head
        while node.next:
            node = node.next

        node.next = Node(value)

    def size(self):
        size = 0
        node = self.head
        while node:
            size += 1
            node = node.next

        return size
    
    def values(self):
        values = []
        node = self.head
        while node:
            if node.value not in values:
                values.append(node.value)
            node = node.next
        return values
            
    def contains(self, value):
        return value in self.values()
        

def union(llist_1, llist_2):
    # Your Solution Here
    new_llist = LinkedList()
    for value in llist_1.values():
        if value not in new_llist.values():
            new_llist.append(value)
    for value in llist_2.values():
        if value not in new_llist.values():
            new_llist.append(value)
    return new_llist
    

def intersection(llist_1, llist_2):
    # Your Solution Here
    new_llist = LinkedList()
    for value in llist_1.values():
        if value in llist_2.values():
            new_llist.append(value)
    return new_llist


# Test case 1

linked_list_1 = LinkedList()
linked_list_2 = LinkedList()

element_1 = [3,2,4,35,6,65,6,4,3,21]
element_2 = [6,32,4,9,6,1,11,21,1]

for i in element_1:
    linked_list_1.append(i)

for i in element_2:
    linked_list_2.append(i)

print (union(linked_list_1,linked_list_2))
# 3 -> 2 -> 4 -> 35 -> 6 -> 65 -> 21 -> 32 -> 9 -> 1 -> 11 -> 
print (intersection(linked_list_1,linked_list_2))
# 4 -> 6 -> 21 -> 

# Test case 2

linked_list_3 = LinkedList()
linked_list_4 = LinkedList()

element_1 = [3,2,4,35,6,65,6,4,3,23]
element_2 = [1,7,8,9,11,21,1]

for i in element_1:
    linked_list_3.append(i)

for i in element_2:
    linked_list_4.append(i)

print (union(linked_list_3,linked_list_4))
# 3 -> 2 -> 4 -> 35 -> 6 -> 65 -> 23 -> 1 -> 7 -> 8 -> 9 -> 11 -> 21 -> 
print (intersection(linked_list_3,linked_list_4))
# 

# Test case 3

linked_list_5 = LinkedList()
linked_list_6 = LinkedList()

element_1 = [1, 2, 3]
element_2 = [1, 2 ,4]

for i in element_1:
    linked_list_5.append(i)

for i in element_2:
    linked_list_6.append(i)

print (union(linked_list_5,linked_list_6))
# 1 -> 2 -> 3 -> 4 -> 
print (intersection(linked_list_5,linked_list_6))
# 1 -> 2 -> 