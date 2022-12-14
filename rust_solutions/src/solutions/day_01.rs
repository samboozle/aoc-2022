use crate::util::{
    desc,
    ParseError::{self, ReadError},
};
use std::cmp::max;
use std::fs;

type Backpacks = Vec<Vec<u32>>;

fn parse_input(path: &str) -> Result<Backpacks, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let backpacks = s
            .split("\n\n")
            .into_iter()
            .map(|line| {
                line.split_whitespace()
                    .map(|s| s.to_string().parse::<u32>().unwrap_or(0))
                    .collect::<Vec<u32>>()
            })
            .collect::<Backpacks>();

        Ok(backpacks)
    } else {
        Err(ReadError)
    }
}

fn solution_1(elf_backpacks: &Backpacks) -> u32 {
    elf_backpacks.into_iter().fold(0, |max_calories, backpack| {
        let calories: u32 = backpack.into_iter().sum();
        max(calories, max_calories)
    })
}

fn solution_2(elf_backpacks: &Backpacks) -> u32 {
    elf_backpacks
        .into_iter()
        .fold(Vec::new(), |mut acc, backpack| -> Vec<u32> {
            let len = acc.len();
            let calories: u32 = backpack.iter().sum();

            match len {
                3 => {
                    let least = acc.pop().unwrap();
                    acc.push(max(calories, least));
                    acc.sort_by(desc);
                    acc
                }
                _ => {
                    acc.push(calories);
                    acc.sort_by(desc);
                    acc
                }
            }
        })
        .into_iter()
        .sum()
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let backpacks = parse_input(path)?;

    let answer_1 = solution_1(&backpacks);
    let answer_2 = solution_2(&backpacks);

    Ok((answer_1.to_string(), answer_2.to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_backpacks() -> Backpacks {
        parse_input("assets/d1test.txt").unwrap()
    }

    fn large_backpacks() -> Backpacks {
        parse_input("assets/d1full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_backpacks()), 24_000);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_backpacks()), 45_000);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_backpacks()), 74_711);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_backpacks()), 209_481);
    }
}
