#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 20:14:50 2019

@author: mrodgers
"""

import hashlib
import datetime

class Block:

    def __init__(self, timestamp, data, previous_hash):
      self.timestamp = timestamp
      self.data = data
      self.previous_hash = previous_hash
      self.hash = self.calc_hash()

    def calc_hash(self):
        sha = hashlib.sha256()
        sha.update(self.data.encode('utf-8'))
        sha.update(self.timestamp.isoformat().encode('utf-8'))
        if self.previous_hash:
            sha.update(self.previous_hash.encode('utf-8'))
        return sha.hexdigest()

    def __str__(self):
        string =  'Data: ' + self.data + '\n'
        string += 'Time: ' + self.timestamp.isoformat() + '\n'
        string += 'Hash: ' + self.hash + '\n'
        return string

class Blockchain:

    def __init__(self):
        self.blocks = []
        first_block = Block(datetime.datetime.utcnow(), "Root", None)
        self.blocks.append(first_block)

    def add(self, data):
        block = Block(datetime.datetime.utcnow(), data, self.blocks[-1].hash)
        self.blocks.append(block)

    def get(self, index):
        return self.blocks[index]

    def length(self):
        return len(self.blocks)

    def verify(self, index=None):
        if not index:
            index = len(self.blocks) 
        for index, block in enumerate(self.blocks[:index]):
            if block.hash != block.calc_hash():
                print("Modification detected in block", index)
                return False
        return True

    def __str__(self):
        string = ''
        for index, block in enumerate(self.blocks):
            string += 'Block ' + str(index) + '\n'
            string += str(block)
        return string

# Test Cases
chain = Blockchain()

chain.add("Block Data 1")
chain.add("Block Data 2")
chain.add("Block Data 3")
chain.add("Block Data 4")
print(chain)
#Block 0
#Data: Root
#Time: 2019-07-24T04:38:28.629739
#Hash: d3cbf410664749cab642e6487cb9ee323b7de464fa25893a009a3a8ae6192971
#Block 1
#Data: Block Data 1
#Time: 2019-07-24T04:38:28.629797
#Hash: 3247482da910fc871707eab1e9bef0383499a8752249b484fce4ddd752ad29c9
#Block 2
#Data: Block Data 2
#Time: 2019-07-24T04:38:28.629818
#Hash: aee1f7aced2575748dec213c9751e68de720d6ee6c8ee8efe39a29de88bca26c
#Block 3
#Data: 1
#Time: 2019-07-24T04:38:28.629836
#Hash: 686d6494bf55eb0eb07bb498167c4d613671ae60164e0d8fb96552f7839b33cd
#Block 4
#Data: Block Data 4
#Time: 2019-07-24T04:38:28.629852
#Hash: efd5fb3e3b2789090a31fd8f6f40749de27aa5e85a20c5fae2a1214817c0793a

print("Verification before hacking:", chain.verify())
# True
chain.blocks[3].data = '1'
print("Verification after hacking:", chain.verify())
# False