use crate::util::ParseError::{self, ReadError};
use std::collections::HashSet;
use std::fs;

fn parse_input(path: &str) -> Result<String, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        Ok(s)
    } else {
        Err(ReadError)
    }
}

fn solution_1(input: &String) -> u32 {
    let mut i = 4;
    for window in input.chars().collect::<Vec<char>>().as_slice().windows(4) {
        match HashSet::<&char>::from_iter(window.iter()).len() {
            4 => break,
            _ => (),
        }
        i += 1;
    }
    i
}

fn solution_2(input: &String) -> u32 {
    let mut i = 14;
    for window in input.chars().collect::<Vec<char>>().as_slice().windows(14) {
        match HashSet::<&char>::from_iter(window.iter()).len() {
            14 => break,
            _ => (),
        }
        i += 1;
    }
    i
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let string = parse_input(path)?;

    Ok((
        solution_1(&string).to_string(),
        solution_2(&string).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_line() -> String {
        parse_input("assets/d6test.txt").unwrap()
    }

    fn large_line() -> String {
        parse_input("assets/d6full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_line()), 7);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_line()), 19);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_line()), 1929);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_line()), 3298);
    }
}
