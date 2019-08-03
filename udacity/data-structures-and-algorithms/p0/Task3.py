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
TASK 3:
(080) is the area code for fixed line telephones in Bangalore.
Fixed line numbers include parentheses, so Bangalore numbers
have the form (080)xxxxxxx.)

Part A: Find all of the area codes and mobile prefixes called by people
in Bangalore.
 - Fixed lines start with an area code enclosed in brackets. The area
   codes vary in length but always begin with 0.
 - Mobile numbers have no parentheses, but have a space in the middle
   of the number to help readability. The prefix of a mobile number
   is its first four digits, and they always start with 7, 8 or 9.
 - Telemarketers' numbers have no parentheses or space, but they start
   with the area code 140.

Print the answer as part of a message:
"The numbers called by people in Bangalore have codes:"
 <list of codes>
The list of codes should be print out one per line in lexicographic order with no duplicates.
"""

def isBangalore(call):
    return call[:5] == "(080)"

def isFixedLine(call):
    return call[0] == "("
    
def isMobileLine(call):
    for letter in call:
        if letter == " ":
            return True
    return False

def isTelemarketers(call):
    if call[:3] == "140":
        return True
    return False
    
def extractAreaCodeFixedLine(call):
    number = []
    for letter in call:
        if letter == "(":
            continue
        if letter == ")":
            break
        number.append(letter)
    return "".join(number)

def extractAreaCodeMobileLine(call):
    return call[:4]    

AreaCodes = []
for call in calls:
    if isBangalore(call[0]):
        if isFixedLine(call[1]):        
            tempLine = extractAreaCodeFixedLine(call[1])
            if tempLine not in AreaCodes:
                AreaCodes.append(tempLine)
        if isMobileLine(call[1]):
            tempLine = extractAreaCodeMobileLine(call[1])
            if tempLine not in AreaCodes:
                AreaCodes.append(tempLine)
        if isTelemarketers(call[1]):
            tempLine = "140"
            if tempLine not in AreaCodes:
                AreaCodes.append(tempLine)
            
print("The numbers called by people in Bangalore have codes: ")
AreaCodes.sort()
for code in AreaCodes:
    print(code)

"""
Part B: What percentage of calls from fixed lines in Bangalore are made
to fixed lines also in Bangalore? In other words, of all the calls made
from a number starting with "(080)", what percentage of these calls
were made to a number also starting with "(080)"?

Print the answer as a part of a message::
"<percentage> percent of calls from fixed lines in Bangalore are calls
to other fixed lines in Bangalore."
The percentage should have 2 decimal digits
"""

totalCalls = 0
BangaloreCalls = 0

def isBangalore(call):
    if call[:5] == "(080)":
        return True
    return False

for call in calls:
    if isBangalore(call[0]) and isBangalore(call[1]):
        BangaloreCalls += 1
    if isBangalore(call[0]):
        totalCalls += 1
    
print(round(BangaloreCalls / totalCalls * 100, 2), "percent of calls from fixed lines in Bangalore are calls to other fixed lines in Bangalore.")


