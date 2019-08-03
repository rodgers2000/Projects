from collections import deque

class LRU_Cache(object):

    def __init__(self, capacity):
        # Initialize class variables
        self.cache = {}                           
        self.capacity = capacity
        self.history = deque() # popleft = queue, # pop = stack

    def get(self, key):
        # Retrieve item from provided key. Return -1 if nonexistent. 
        if key in self.cache.keys():    
            self.history.remove(key)
            self.history.append(key)
            return self.cache[key]
        return -1 

    def set(self, key, value):
        # Set the value if the key is not present in the cache. If the cache is at capacity remove the oldest item.
        if key not in self.cache.keys():
            if len(self.cache.keys()) == self.capacity:
                self.cache.pop(self.history.popleft())
            self.history.append(key)
        self.cache[key] = value

# Test Cases
our_cache = LRU_Cache(3)
our_cache.set(1, 1)
our_cache.set(2, 2)
our_cache.set(3, 3)
# 1
our_cache.set(4, 4)
print(our_cache.cache)
# overflow: should change change and get rid of 1
# 2 
print(our_cache.get(1))
# not available: should return -1
# 3
our_cache.set(3, 100)
print(our_cache.cache.items())
# new value: should set a new value