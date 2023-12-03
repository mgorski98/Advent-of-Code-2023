use std::fs::read_to_string;

fn read_lines(filename: &str) -> Vec<String> {
    let mut result = Vec::new();

    for line in read_to_string(filename).unwrap().lines() {
        result.push(line.to_string());
    }

    result
}

fn main(){
    let lines = read_lines("input.txt");
    for line in lines{
        println!("{}", line);
    }
}