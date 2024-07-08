import sys
import math


if len(sys.argv) < 2:
    print("Not enough arguments")
    quit()


num_terminals = int(sys.argv[1])
rows = 0
cols = 0


closest_sqrt = math.ceil(math.sqrt(num_terminals))
closest_sqr = closest_sqrt ** 2
cols = closest_sqrt
rows = cols

while ((rows * cols) - num_terminals) >= closest_sqrt:
    rows -= 1

print(rows, cols)