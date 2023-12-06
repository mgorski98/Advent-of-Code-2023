import re
from collections import defaultdict
import multiprocessing as mp
import datetime

def parse_inputs(lines):
    seeds = list(map(int, lines[0].split(': ')[1].split(' ')))
    data = filter(lambda s: not s.isspace(), lines[2::])
    src, dest = '', ''
    nums_map = defaultdict(list)
    for line in data:
        if re.match(r'.*\-to\-.*\:', line):
            src, dest = line.split('-to-')
            dest = dest.replace(':','').replace('map','').strip()
        else:
            nums_map[(src, dest)].append(list(map(int, line.split(' '))))
    return seeds, nums_map

def solve(seed_numbers, mapping_data, notify_when_finished=True):
    result = 100000000000000000
    curvalue = 0
    for seed_num in seed_numbers:
        curvalue = seed_num
        for key in mapping_data.keys():
            vals_list = mapping_data[key]
            for range_data in vals_list:
                dest_start, src_start, length = range_data
                end = src_start + length
                is_in_range = src_start <= curvalue < end
                if is_in_range:
                    offset = curvalue - src_start
                    curvalue = dest_start + offset
                    break
            if key[1] == 'location':
                if curvalue <= result:
                    result = curvalue
    if notify_when_finished:
        print(f"Finished processing! current time: {datetime.datetime.now()}")
    return result

def solve_concurrent(ranges_data, mapping_data):
    with mp.Pool(len(ranges_data) // 2) as pool:
        values = pool.starmap(solve, [[range(r[0],r[0]+r[1]), mapping_data] for r in ranges_data])
        return min(values)

def part1(lines):
    seed_numbers, mapping_data = parse_inputs(lines)
    result = solve(seed_numbers, mapping_data, False)
    print(result)

def part2(lines):
    seed_numbers, mapping_data = parse_inputs(lines)
    ranges_data = list(zip(seed_numbers[0::2], seed_numbers[1::2]))
    result = solve_concurrent(ranges_data, mapping_data)
    print(result)


if __name__ == "__main__":
    with open('input.txt', mode='r') as f:
        lines = f.readlines()

    part1(lines)
    part2(lines)