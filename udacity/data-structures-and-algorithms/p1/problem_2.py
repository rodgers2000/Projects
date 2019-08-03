#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 16:15:54 2019

@author: mrodgers
"""

import os

def find_files(suffix, path):
    """
    Find all files beneath path with file name suffix.

    Note that a path may contain further subdirectories
    and those subdirectories may also contain further subdirectories.

    There are no limit to the depth of the subdirectories can be.

    Args:
      suffix(str): suffix if the file name to be found
      path(str): path of the file system

    Returns:
       a list of paths
    """
    paths = []
    
    # if a file
    if os.path.isfile(path):
        if path.endswith(suffix):
            paths.append(path)
    # if a directory
    elif os.path.isdir(path):
        for baby_path in os.listdir(path):
            paths.extend(find_files(suffix, (path + '/' + baby_path)))
    return paths

# Test Cases
# 1
print(find_files(".c", "testdir"))
#['testdir/subdir3/subsubdir1/b.c', 'testdir/t1.c', 'testdir/subdir5/a.c', 'testdir/subdir1/a.c']
# 2
print(find_files(".h", "testdir"))
#['testdir/subdir3/subsubdir1/b.h', 'testdir/subdir5/a.h', 'testdir/t1.h', 'testdir/subdir1/a.h']
# 3
print(find_files(".py", "testdir"))
#[]