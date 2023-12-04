def parse_nums(input)
    winning_nums, my_nums = input.split(': ')[1].split('|')
    winning_nums = winning_nums.split.map { |n| n.to_i }
    my_nums = my_nums.split.map { |n| n.to_i }
    [winning_nums, my_nums]
  end
  
  def part1(input)
    sum = 0
    input.each do |line|
      winning_nums, my_nums = parse_nums(line)
      intersection = my_nums & winning_nums
      sum += 2**(intersection.length - 1) if intersection.length > 0
    end
    p "part1: #{sum}"
  end
  
  def part2(input)
    total_cards = Hash.new(1)
    input.each_with_index { |l,i| total_cards[i] = 1 }
  
    input.each_with_index do |line, idx|
      winning_nums, my_nums = parse_nums(line)
      intersection = my_nums & winning_nums
      count = intersection.length
      next unless count > 0
  
      (0..(count-1)).each do |i|
        total_cards[i + idx + 1] += total_cards[idx]
      end
    end
  
    p "part2: #{total_cards.values.sum}"
  end
  
  lines = File.readlines('input.txt', chomp: true).to_a
  
  part1 lines
  part2 lines
  