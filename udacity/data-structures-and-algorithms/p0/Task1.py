"""
Read file into texts and calls.
It's ok if you don't understand how to read files.
"""
import csv
with open('texts.csv', 'r') as f:
    reader = csv.reader(f)
    texts = list(reader)

with open('calls.csv', 'r') as f:
    reader = csv.reader(f)
    calls = list(reader)


"""
TASK 1:
How many different telephone numbers are there in the records? 
Print a message:
"There are <count> different telephone numbers in the records."
"""

numbers = []

for i in range(len(calls)):
    for j in range(2):
        if calls[i][j] not in numbers:
            numbers.append(calls[i][j])

for i in range(len(texts)):
    for j in range(2):
        if texts[i][j] not in numbers:
            numbers.append(texts[i][j])
            
print("There are", len(numbers), "different telephone numbers in the record.")