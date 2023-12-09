from sys import argv

def parse_input(lines):
    return list(map(lambda l: list(map(int, l)), map(str.split, lines)))

def get_diff_sequences(nums):
    sequences = [list(nums)]
    current_seq = nums
    while not all(x == 0 for x in current_seq):
        next_seq = []
        for i in range(len(current_seq) - 1):
            c, n = current_seq[i], current_seq[i+1]
            next_seq.append(n - c)
        current_seq = next_seq
        sequences.append(current_seq)
    return sequences

def find_next_number(nums):
    sequences = list(reversed(get_diff_sequences(nums)))
    for s in sequences:
        s.append(0)
    for i in range(len(sequences) - 1):
        s1, s2 = sequences[i], sequences[i+1]
        s2[-1] = s2[-2] + s1[-1]
    return sequences[-1][-1]

def find_prev_number(nums):
    sequences = list(reversed(get_diff_sequences(nums)))
    for s in sequences:
        s.insert(0, 0)
    for i in range(len(sequences) - 1):
        s1, s2 = sequences[i], sequences[i+1]
        s2[0] = s2[1] - s1[0]
    return sequences[-1][0]

def part1(_input):
    result = sum(map(find_next_number, _input))
    print(f"result = {result}")

def part2(_input):
    result = sum(map(find_prev_number, _input))
    print(f"result = {result}")

if __name__ == '__main__':
    if (len(argv)) <= 1:
        print("no input")

    path = argv[1]

    with open(argv[1], mode='r') as f:
        lines = f.readlines()

    _input = parse_input(lines)

    part1(_input)
    part2(_input)