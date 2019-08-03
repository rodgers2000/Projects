# Problem 1 - LRU Cache

## Approach

This problem envolved setting up an LRU Cache. The LRU Cache has a limited amount of space and uses a queue to find the oldest element and erase it to add a new one.
The cache needs to be a map because it holds a key, value pair. 

## Efficiency

All complexity is O(1). The get operation is O(n) because of the remove method. The worst case is O(n).
The larger the cache, the larger memory space it takes, and therefore will slow down the program. 
The space complexity is O(n).

# Problem 2 - Find files

## Approach

Here I used a recursive algorithm to search into the directories and then to check files for the pattern. 
I used a list data structure in each recursive call. This was complemented by the extend method. If you extend a list by an empty list, you receive the old list. 
Therefore, if the path did not lead to a file with the suffix, it received an empty list. 

## Efficiency

It is O(1) for looking up whether or not it's a directory or file. The complexity of the recursion depends on the folders, but each call, if there are m directories and n files is O(m*n).
The space complexity is O(m * n) in total for each folder and file recursion.

# Problem 3 - Huffman Encoding

## Approach

I used a map to collect character frequencies, and then turned that into a sorted list.
The frequency list contains the actual tree nodes. This simplifies the algorithm for building the tree since the nodes are a binary structure. 
To build the tree, I used the nodes and combined them based on the sorted order to reach a length of 1.
To trim the tree, I used a recursive algorithm. I used the map data structure to store the code for each character. 
The update method for dictionaries was useful because updating an empty dictionary to an existing one keeps the existing one the same. 
To decode the tree, I used a recursive algorithm to keep track of the 0's and 1's, and expanded down the binary tree nodes. 
The huffman encoding and decoding used these methods.

## Efficiency

create_frequency_list: time: O(n) space: O(n)
sort_frequencies: O(n log n) space: O(n)
build_huff_tree: O(n) space: O(n)
trim_huff_tree: O(n) space: O(n * m) where n is the depth of the tree and m is the codes
decode_next: O(n) space: O(n)
huffman_encoding: O(n) space: O(n)
huffman_decoding: O(n) space: O(n)

# Problem 4 - User in group

## Approach

I used a recursive algorithm that returns once the answer is true or false. This was similar to the file recursion algorithm. 
The data structures used were a class, which contained the groups. This was how the problem was set up. 

## Efficiency

This algorithm has a complexity of O(n), where n is the number of users. This is because each user will be checked once.
The space analysis is O(1) because we are returning true or false. 

# Problem 5 - Blockchain

## Approach

I used a list and a Block class to build the blockchain. This allows simple appending, and direct access to blocks by indexing.
I also made a verify method to check if the data has been changed or that the timestamps have been modified. 

## Efficiency

All operations are basic list modifications: O(1).
Space analysis is O(n), where n is the number of blocks. 

# Problem 6 - List union & intersection

## Approach

This problem was straight forward. The union added all unique elements to a new linked list. 
The intersection added all common elements to a new linked list. 
I used a linked list data structure because that's how the problem was set up. 

## Efficiency

The union algorithm has a complexity of O(n^2). The intersection algorithm has a complexity of O(n).
The space analysis is O(n * m), where n and m are the lengths of the two input linked lists.