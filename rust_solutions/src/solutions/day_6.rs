use crate::util::ParseError::{self, ReadError};
use std::collections::{HashMap, HashSet};
use std::fs;

fn parse_input(path: &str) -> Result<String, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        Ok(s)
    } else {
        Err(ReadError)
    }
}

fn solution_1(input: &String) -> u32 {
    first_unique_window_sized_mut(input, 4)
}

fn solution_2(input: &String) -> u32 {
    first_unique_window_sized_mut(input, 14)
}

// My original implementation; find the first window of `size` width (e.g., 4)
// where all elements are unique
fn _first_unique_window_sized(input: &String, size: usize) -> u32 {
    type VC = Vec<char>; // give this type a short name so rustfmt chills :)
    let mut i = size;
    for window in input.chars().collect::<VC>().as_slice().windows(size) {
        match HashSet::<&char>::from_iter(window.iter()).len() {
            x if x == size => break,
            _ => (),
        }
        i += 1;
    }
    i as u32
}

// My second implementation; use a hashmap to track the counts of all characters
// within a window of width `size`. When the window reaches `size` entries in length,
// terminate. Not sure if it's significantly better, but tracking the windowed char set globally
// rather than per-window seems more efficient..
fn first_unique_window_sized_mut(input: &String, size: usize) -> u32 {
    let indexible = input.chars().collect::<Vec<char>>();
    let mut counter = HashMap::new();
    let mut i = 0;

    loop {
        *counter.entry(indexible[i]).or_insert(0) += 1;

        if size <= i {
            let exited = indexible[i - size];

            counter.entry(exited).and_modify(|e| *e -= 1);

            if let Some(0) = counter.get(&exited) {
                counter.remove(&exited);
            }
        }

        i += 1;

        if counter.len() == size {
            break;
        }
    }

    i as u32
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
