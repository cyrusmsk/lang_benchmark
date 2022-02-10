import random

folder = "../sample/"
file_name = "sample_"
max_length_row = 50
min_length_row = 5
number_of_rows = 1000000

with open(folder + file_name + str(number_of_rows) + '.csv', 'w') as f:
    for i_row in range(number_of_rows):
        row = "1"
        for i in range(random.choice([i for i in range(min_length_row, max_length_row + 1)])):
            row += str(random.choices([0, 1], [0.45, 0.55])[0])
        f.write(row)
        f.write('\n')
