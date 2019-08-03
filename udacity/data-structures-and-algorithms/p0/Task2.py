"""
Read file into texts and calls.
It's ok if you don't understand how to read files
"""
import csv
with open('texts.csv', 'r') as f:
    reader = csv.reader(f)
    texts = list(reader)

with open('calls.csv', 'r') as f:
    reader = csv.reader(f)
    calls = list(reader)

"""
TASK 2: Which telephone number spent the longest time on the phone
during the period? Don't forget that time spent answering a call is
also time spent on the phone.
Print a message:
"<telephone number> spent the longest time, <total time> seconds, on the phone during 
September 2016.".
"""

numbers = {}

for call in calls:
    if call[0] not in numbers:
        numbers[call[0]] = 0
    if call[1] not in numbers:
        numbers[call[1]] = 0
    numbers[call[0]] += int(call[3])
    numbers[call[1]] += int(call[3])
    
maxNumber = 0
maxTime = 0

for number in numbers:
    if maxNumber == 0 or numbers[number] > maxTime:
        maxNumber = number
        maxTime = numbers[number]

print(maxNumber, "spent the longest time", maxTime, "seconds, on the phone during September 2016.")