use std::fs::read_to_string;
use std::collections::HashMap;
use std::fmt;

#[derive(Eq, PartialEq, PartialOrd, Ord, Debug)]
enum HandResult {
    HighCard(i32),
    OnePair(i32),
    TwoPair(i32), 
    ThreeOfAKind(i32), 
    FullHouse(i32),
    FourOfAKind(i32), 
    FiveOfAKind(i32)
}

#[derive(Eq, PartialEq)]
struct CardHand {
    cards: HashMap<char, u32>,
    bid: u32,
    hand: String,
    cards_map: HashMap<char, u32>
}

impl CardHand {
    fn get_hand_result(&self) -> HandResult {
        if self.cards.values().all(|v| *v == 1) {
            return HandResult::HighCard(0);
        }
        if self.cards.len() == 1 {
            return HandResult::FiveOfAKind(6);
        }
        if self.cards.len() == 2 {
            if self.cards.values().any(|v| *v == 4) {
                return HandResult::FourOfAKind(5);
            }
            return HandResult::FullHouse(4);
        }
        if self.cards.len() == 3 {
            if self.cards.values().any(|v| *v == 3){
                return HandResult::ThreeOfAKind(3);
            }
            return HandResult::TwoPair(2);
        }
        HandResult::OnePair(1)
    }

    pub fn new(cards: HashMap<char, u32>, bid: u32, hand: String, is_joker: bool) -> Self {
        CardHand {
            cards,bid,hand, cards_map: HashMap::from([
                ('A',140),
                ('K', 130),
                ('Q', 120),
                ('J', if is_joker {10} else {110}),
                ('T',100),
                ('9', 90),
                ('8', 80),
                ('7', 70),
                ('6', 60),
                ('5', 50),
                ('4', 40),
                ('3', 30),
                ('2', 20)
            ])
        }
    }

    pub fn modify_card(&mut self, target_card: char, increase: u32) {
        let old_count = self.cards.get(&target_card).unwrap();
        self.cards.insert(target_card, increase + old_count);
    }
}

impl fmt::Display for CardHand {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "hand: {}, bid: {}\n", self.hand, self.bid);
        for (k, v) in self.cards.iter() {
            write!(f, "{} - {}\n", k,v);
        }
        write!(f, "hand result = {:?}", self.get_hand_result());
        return fmt::Result::Ok(());
    }
}

impl Clone for CardHand {
    fn clone(&self) -> Self {
        CardHand {
            cards: self.cards.clone(),
            bid: self.bid,
            hand: self.hand.clone(),
            cards_map: self.cards_map.clone()
        }
    }
}

impl Ord for CardHand {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        let res1 = self.get_hand_result();
        let res2 = other.get_hand_result();
        if res1 == res2 {
            for (c1, c2) in self.hand.chars().zip(other.hand.chars()) {
                if c1 != c2 {
                    let v1 = self.cards_map.get(&c1).unwrap();
                    let v2 = self.cards_map.get(&c2).unwrap();
                    return v1.cmp(v2);
                }
            }
            return std::cmp::Ordering::Equal
        }else{
            return res1.cmp(&res2);
        }
    }
}

impl PartialOrd for CardHand{
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename).unwrap().lines().map(|s| String::from(s)).collect()
}

fn parse_input(input: &Vec<String>, ispart2: bool) -> Vec<CardHand> {
    let mut result: Vec<CardHand> = Vec::new();
    for line in input.iter() {
        let parts: Vec<&str> = line.split(' ').collect();
        let bid: u32 = parts[1].parse::<u32>().unwrap();
        let mut counter:HashMap<char, u32> = HashMap::new(); 
        for c in parts[0].chars() {
            let exists = counter.get(&c);
            match exists {
                None => counter.insert(c, 1),
                Some(i) => counter.insert(c, i+1)
            };
        }
        result.push(CardHand::new(counter, bid, parts[0].to_string(), ispart2));
    }
    result
}

fn count_winnings(input: &Vec<CardHand>) -> u64 {
    let mut total_winnings: u64 = 0;
    for (i, item) in input.iter().enumerate() {
        total_winnings += (item.bid * (i+1) as u32) as u64;
    }
    total_winnings
}

fn part1(input: &Vec<CardHand>) {
    let mut copy: Vec<CardHand> = input.clone().to_vec();
    copy.sort();
    println!("result = {}", count_winnings(&copy));
}

fn get_best_card_from_hand(card_hand: &CardHand) -> Option<&char> {
    let max_val = card_hand.cards.iter().filter(|pair| *(pair.0) != 'J').map(|pair| *pair.1).max();
    return match max_val {
        None => None,
        Some(val) => {
            let max_val_cards: Vec<&char> = card_hand.cards.keys().filter(|k| *card_hand.cards.get(&k).unwrap() == val && **k != 'J').collect();
            let max_card = max_val_cards.into_iter().max_by(|c1, c2| card_hand.cards_map.get(c1).unwrap().cmp(card_hand.cards_map.get(c2).unwrap()));
            max_card
        }
    }
}

fn part2(input: &Vec<CardHand>) {
    let mut copy: Vec<CardHand> = input.clone().to_vec();
    for card_hand in copy.iter_mut() {
        let jokers = card_hand.cards.get(&'J');
        match jokers {
            None => continue,
            Some(count) => {
                let card_to_increase = get_best_card_from_hand(&card_hand);
                match card_to_increase {
                    None => continue,
                    Some(card) => {
                        card_hand.modify_card(*card, *count);
                        card_hand.cards.remove(&'J');
                    }
                }
            }
        }
    }
    copy.sort();
    println!("result = {}", count_winnings(&copy));
}

fn main() {
    let lines = read_lines("input.txt");
    let cards_part1 = parse_input(&lines, false);
    let cards_part2 = parse_input(&lines, true);
    part1(&cards_part1);
    part2(&cards_part2);
}