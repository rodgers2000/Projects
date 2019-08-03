#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 16:48:36 2019

@author: mrodgers
"""

class Group:
    def __init__(self, name):
        self.name = name
        self.groups = []
        self.users = []

    def add_group(self, group):
        self.groups.append(group)

    def add_user(self, user):
        self.users.append(user)

    def get_groups(self):
        return self.groups

    def get_users(self):
        return self.users

    def get_name(self):
        return self.name


parent = Group("parent")
child = Group("child")
sub_child = Group("subchild")

sub_child_user = "sub_child_user"
sub_child.add_user(sub_child_user)

child.add_group(sub_child)
parent.add_group(child)

def is_user_in_group(user, group):
    
    if user in group.get_groups():
        return True
    if len(group.get_groups()) == 0:
        return False
    for subgroup in group.get_groups():
        return is_user_in_group(user, subgroup)    
    
# Test Cases

print(is_user_in_group("parent_user", parent))
#False
print(is_user_in_group("child_user", child))
#False
print(is_user_in_group("sub_child_user", sub_child))
#False
print(is_user_in_group("sub_child_user", child))
#False
print(is_user_in_group("sub_child_user", parent))
#False
print(is_user_in_group("parent_user", child))
#False
print(is_user_in_group("child_user", sub_child))
#False