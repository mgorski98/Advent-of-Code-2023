import re

DIGITS_MAP = {
    'one':1,
    'two':2,
    'three':3,
    'four':4,
    'five':5,
    'six':6,
    'seven':7,
    'eight':8,
    'nine':9
}

def read_input(path:str):
    with open(path, mode='r') as f:
        return f.readlines()
    
def all_occurences(s: str, element: str) -> [int]:
    return [x.start() for x in re.finditer(element, s)]

def get_calibration_value(line: str) -> int:
    nums = [x for x in line if x.isdigit()]
    return int(nums[0] + nums[-1]) if len(nums) > 0 else 0

def get_calibration_value_from_words_and_nums(line:str) -> int:
    digits = [(i, x) for i,x in enumerate(line) if x.isdigit()]
    words = [(all_occurences(line, x), x) for x in DIGITS_MAP.keys() if x in line]
    new_words = []
    for index_list, word in words:
        for index in index_list:
            new_words.append((index, word))
    words = new_words
    sort_key = lambda pair: pair[0]
    words.sort(key=sort_key)
    digits.sort(key=sort_key)
    if (len(digits) <= 0):
        return int(str(DIGITS_MAP[words[0][1]]) + str(DIGITS_MAP[words[-1][1]]))
    if len(words) <= 0:
        return get_calibration_value(line)
    min_digits, max_digits = min(digits, key=sort_key), max(digits, key=sort_key)
    min_words, max_words = min(words, key=sort_key), max(words, key=sort_key)
    str_num = ''
    str_num += str(min_digits[1] if min_digits[0] < min_words[0] else DIGITS_MAP[min_words[1]])
    str_num += str(max_digits[1] if max_digits[0] > max_words[0] else DIGITS_MAP[max_words[1]])
    return int(str_num)

def run(calibration_mapper):
    lines = read_input("input.txt")
    nums = map(calibration_mapper, lines)
    s = sum(nums)
    print(f"Result: {s}")

# part 1
run(get_calibration_value)
#part 2
run(get_calibration_value_from_words_and_nums)
