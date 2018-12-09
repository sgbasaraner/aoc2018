class Claim:
    def __init__(self, string):
        splitted = string.split()
        self.id = splitted[0].strip('#')
        self.left = int(splitted[2].split(',')[0])
        self.top = int(splitted[2].split(',')[1].strip(':'))
        self.width = int(splitted[3].split('x')[0])
        self.height = int(splitted[3].split('x')[1])

    def pairs(self):
        pairs = []
        for i in range(self.width):
            for j in range(self.height):
                pairs.append((self.left + i, self.top + j))

        return pairs

fh = open("input.txt","r")
input = fh.read()
fh.close()


lined = input.splitlines()
claims = list(map(lambda x: Claim(x), lined))

dictionary = dict()
for claim in claims:
    for pair in claim.pairs():
        if dictionary.get(pair) == None:
            dictionary[pair] = 1
        else: 
            dictionary[pair] = dictionary[pair] + 1


# part one:
print(len(list(filter(lambda x: x > 1, dictionary.values()))))

# part two:
intact_pairs = []
for key, value in dictionary.items():
    if value == 1:
        intact_pairs.append(key)

intact_claim = None
for claim in claims:
    intact = True
    for pair in claim.pairs():
        if pair not in intact_pairs:
            intact = False
            break

    if intact:
        intact_claim = claim
        break

print(intact_claim.id)