use std::collections::HashSet;
use std::fs;
use std::hash::Hash;
use std::iter::FromIterator;

use crate::util::ParseError::{self, ReadError};

type Rucksacks = Vec<String>;

fn parse_input(path: &str) -> Result<Rucksacks, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let rucksacks = s
            .split_whitespace()
            .into_iter()
            .fold(vec![], |mut acc, sack| {
                acc.push(sack.to_owned());
                acc
            });

        Ok(rucksacks)
    } else {
        Err(ReadError)
    }
}

fn priority(c: char) -> u32 {
    match c {
        'a'..='z' => c as u32 - 96,
        'A'..='Z' => c as u32 - 38,
        _ => 0,
    }
}

fn solution_1(rucksacks: &Rucksacks) -> u32 {
    rucksacks.into_iter().fold(0, |acc, sack| {
        let half = sack.len() / 2;
        let mut seen = HashSet::new();

        for (i, c) in sack.char_indices() {
            if i < half {
                seen.insert(c);
            } else if seen.contains(&c) {
                return acc + priority(c);
            }
        }

        acc + 0
    })
}

fn solution_2(rucksacks: &Rucksacks) -> u32 {
    rucksacks.chunks(3).into_iter().fold(0, |acc, three| {
        let common_char = three
            .into_iter()
            .map(|s| HashSet::from_iter(s.chars()))
            // Original intersection reduce requires cloning -> .reduce(|acc: HashSet<char>, set| acc.intersection(&set).cloned().collect())
            .reduce(mut_intersection) // Does not require cloning
            .unwrap()
            .drain()
            .next()
            .unwrap();

        acc + priority(common_char)
    })
}

fn mut_intersection<T: Eq + Hash>(mut a: HashSet<T>, b: HashSet<T>) -> HashSet<T> {
    a.retain(|el| b.contains(el));
    a
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let rucksacks = parse_input(path)?;

    let answer_1 = solution_1(&rucksacks);
    let answer_2 = solution_2(&rucksacks);

    Ok((answer_1.to_string(), answer_2.to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_rucksacks() -> Rucksacks {
        parse_input("assets/d3test.txt").unwrap()
    }

    fn large_rucksacks() -> Rucksacks {
        parse_input("assets/d3full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_rucksacks()), 157);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_rucksacks()), 70);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_rucksacks()), 7_581);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_rucksacks()), 2_525);
    }
}
