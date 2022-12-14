use crate::util::ParseError::{self, ReadError};
use std::fs;

#[derive(Debug, Clone)]
enum Packet {
    Nil,
    Cons(Box<Node>, Box<Packet>),
}

#[derive(Debug, Clone)]
enum Node {
    Val(u8),
    List(Packet),
}

use Node::*;
use Packet::*;

impl Packet {
    fn from_str(s: &str) -> Packet {
        let segments = s
            .chars()
            .fold((vec![], String::new()), |(mut acc, mut val), rune| {
                match rune {
                    '0'..='9' => val.push(rune),
                    '[' => acc.push("[".to_string()),
                    ']' => {
                        match val.parse::<u8>() {
                            Ok(_) => acc.push(val.to_owned()),
                            Err(_) => (),
                        }
                        val.clear();
                        acc.push("]".to_string())
                    }
                    ',' => {
                        match val.parse::<u8>() {
                            Ok(_) => acc.push(val.to_owned()),
                            Err(_) => (),
                        }
                        val.clear();
                    }
                    _ => (),
                }

                (acc, val)
            })
            .0;

        // segments.reverse();

        Self::parse(segments)
    }

    fn parse(segments: Vec<String>) -> Packet {
        match segments.pop() {
            Some(str) => match str.as_str() {
                "]" => Nil,
                "[" => ,
            },
            None => Nil,
        }
    }
}

fn parse_input(path: &str) -> Result<Vec<Packet>, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let packets = s
            .trim()
            .split("\n\n")
            // .skip(1)
            .take(1)
            .flat_map(|pair| pair.split("\n").map(Packet::from_str))
            .collect::<Vec<Packet>>();

        println!("{:?}", packets);

        Ok(packets)
    } else {
        Err(ReadError)
    }
}

fn solution_1(packets: &Vec<Packet>) -> usize {
    0
}

fn solution_2(packets: &Vec<Packet>) -> usize {
    0
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let motions = parse_input(path)?;

    Ok((
        solution_1(&motions).to_string(),
        solution_2(&motions).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_commands() -> Vec<Packet> {
        parse_input("assets/d13test.txt").unwrap()
    }

    fn large_commands() -> Vec<Packet> {
        parse_input("assets/d13full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_commands()), 13);
    }

    // #[test]
    // fn test_large_input_solution_1() {
    //     assert_eq!(solution_1(&large_commands()), 5_843);
    // }

    // #[test]
    // fn test_small_input_solution_2() {
    //     assert_eq!(solution_2(&small_commands()), 1);
    // }
    //
    // #[test]
    // fn test_large_input_solution_2() {
    //     assert_eq!(solution_2(&large_commands()), 2_482);
    // }
}
