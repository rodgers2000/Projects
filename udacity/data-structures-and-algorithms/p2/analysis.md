# Problem 1 - Floored Square Root

## Approach
I used Newton's square root algorithm. This approach uses Newton's method to minimize a function. The while loop terminates when the next guess is equal to the last guess.

## Efficiency
Time complexity: O(log n)
Space complexity: O(1)

# Problem 2 - Rotated Array Search

## Approach
I found the pivot using pivot search, a divide and conquer algorithm, then found the requested index using a normal binary search in the correct half of the array.

## Efficiency
Time complexity: O(log n + log n - 1) = O(log n)
Space complexity: O(1)

# Problem 3 - Rearrange Array Digits

## Approach
The array is sorted using quicksort, in order to be able to find the largest sums in the second step.
The sum is then simply formed by traversing the array and multiplying the factor by 10 at every second step.

## Efficiency
Time complexity: O(n log n + n) = O(n log n)
Space complexity: O(1)

# Problem 4 - Dutch National Flag

## Approach
The problem solution was given in the course materials.

## Efficiency
Time complexity: O(n)
Space complexity: O(n)

# Problem 5 - Autocomplete with Tries

## Approach
This relies on a trie implementation. The node's children are kept in a dict that maps every possible follow-up character to another node. If a word is completed, the flag is set to True. 

## Efficiency
Time complexity: O(n).
Space complexity: O(n * m), where n is the number of words stored in the trie and m is the longest word length.

# Problem 6 - Unsorted Integer Array

## Approach
I set the initial max and min to the first element of the array. Then looped through the array and updated the min and max if it was necessary.

## Efficiency
Time complexity: O(n)
Space complexity: O(n) 

# Problem 7 - Routing with Tries

## Approach
This uses the trie data strucuture, just using path elements instead of characters as dict keys. Instead of the word end marker, here the handler is attached to the end nodes.

## Efficiency
Time complexity is O(n),  where n is the longest path.
Space complexity is O(n), where n is the number of paths stored in the trie.