#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 20:33:47 2019

@author: mrodgers
"""
import sys

class HuffNode:
    def __init__(self, char, freq):
        self.char = char
        self.freq = freq
        self.left = None
        self.right = None

    def is_leaf(self):
        return not (self.left or self.right)

def create_frequency_list(data):
    frequency_map = {}
    for char in data:
        if char not in frequency_map.keys():
            frequency_map[char] = 1
        else:
            frequency_map[char] += 1
    frequencies = []
    for char, freq in frequency_map.items():
        frequencies.append(HuffNode(char, freq))
    return frequencies

def sort_frequencies(frequencies):
    sorted_frequencies = sorted(frequencies, key=lambda x: x.freq, reverse=True)
    return sorted_frequencies

def build_huff_tree(text):
    frequencies = create_frequency_list(text)
    frequencies = sort_frequencies(frequencies)
    while len(frequencies) > 1:
        left = frequencies.pop()
        right = frequencies.pop()
        freq_sum = left.freq + right.freq
        parent = HuffNode(None, freq_sum)
        parent.left = left
        parent.right = right
        frequencies.append(parent)
        frequencies = sort_frequencies(frequencies)
    return frequencies[0]

def trim_huff_tree(tree, code):
    huff_map = {}
    if not tree:
        return huff_map
    if tree.is_leaf():
        huff_map[tree.char] = code
    huff_map.update(trim_huff_tree(tree.left, code + '0'))
    huff_map.update(trim_huff_tree(tree.right, code + '1'))
    return huff_map

def decode_next(data, index, tree):
    if tree.is_leaf():
        return tree.char, index
    if data[index] == '0':
        return decode_next(data, index + 1, tree.left)
    else:
        return decode_next(data, index + 1, tree.right)

def huffman_encoding(text):
    huff_tree = build_huff_tree(text)
    huff_map = trim_huff_tree(huff_tree, '')
    data = ''
    for char in text:
        data += huff_map[char]
    return data, huff_tree

def huffman_decoding(data, tree):
    text, next_index = decode_next(data, 0, tree)
    while next_index < len(data):
        next_char, next_index = decode_next(data, next_index, tree)
        text += next_char
    return text

def test_encoding(text):
    print("Original Text: {}".format(text))
    print("Size: {}".format(sys.getsizeof(text)))
    
    encoded_data, tree = huffman_encoding(text)
    print("Huffman Encoding: {}".format(encoded_data))
    print("Size: {}".format(sys.getsizeof(int(encoded_data, base=2))))
    
    decoded_data = huffman_decoding(encoded_data, tree)
    print("Decoded Text: {}".format(decoded_data))
    print("Size: {}".format(sys.getsizeof(decoded_data)))
    
    return decoded_data == text

# Test Cases

# 1
print(test_encoding("AB"))
#Original Text: AB
#Size: 51
#Huffman Encoding: 10
#Size: 28
#Decoded Text: AB
#Size: 51
#True

# 2
print(test_encoding("TestTestTest"))
#Original Text: TestTestTest
#Size: 61
#Huffman Encoding: 010011100100111001001110
#Size: 28
#Decoded Text: TestTestTest
#Size: 61
#True

# 3
print(test_encoding("The bird is the word"))
#Original Text: The bird is the word
#Size: 69
#Huffman Encoding: 1110100100010111000110101101100111111110111100010001011001110000101101
#Size: 36
#Decoded Text: The bird is the word
#Size: 69
#True