use crate::util::ParseError::{self, ReadError};
use std::cmp::{max, Ordering};
use std::collections::HashSet;
use std::fs;

use Ordering::*;

fn parse_input(path: &str) -> Result<Vec<Vec<u8>>, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let forest = s
            .trim()
            .split("\n")
            .map(|line| line.chars().map(|c| c as u8).collect::<Vec<u8>>())
            .collect::<Vec<Vec<u8>>>();
        Ok(forest)
    } else {
        Err(ReadError)
    }
}

fn solution_1(forest: &Vec<Vec<u8>>) -> usize {
    let row_len = forest[0].len();
    let mut y_maxs = vec![47; row_len];
    let mut visible = HashSet::new();

    for (i, row) in forest.into_iter().enumerate() {
        let mut x_max = 47;
        for (j, tree) in row.into_iter().enumerate() {
            if let Greater = tree.cmp(&x_max) {
                x_max = *tree;
                visible.insert((i, j));
            }

            if let Greater = tree.cmp(&y_maxs[j]) {
                y_maxs[j] = *tree;
                visible.insert((i, j));
            };
        }
    }

    y_maxs.fill(47);

    for (i, row) in forest.into_iter().enumerate().rev() {
        let mut x_max = 47;
        for (j, tree) in row.into_iter().enumerate().rev() {
            if let Greater = tree.cmp(&x_max) {
                x_max = *tree;
                visible.insert((i, j));
            }

            if let Greater = tree.cmp(&y_maxs[j]) {
                y_maxs[j] = *tree;
                visible.insert((i, j));
            };
        }
    }

    visible.len()
}

fn solution_2(forest: &Vec<Vec<u8>>) -> usize {
    let col_len = forest.len();
    let row_len = forest[0].len();
    let mut max_score = 0;

    for (i, row) in forest.into_iter().enumerate().skip(1) {
        for (j, tree) in row.into_iter().enumerate().skip(1) {
            let mut left = 0;
            let mut right = 0;
            let mut up = 0;
            let mut down = 0;

            for k in (0..j).rev() {
                left += 1;
                if let Greater = tree.cmp(&forest[i][k]) {
                    continue;
                }
                break;
            }

            for k in (j + 1)..row_len {
                right += 1;
                if let Greater = tree.cmp(&forest[i][k]) {
                    continue;
                }
                break;
            }

            for h in (0..i).rev() {
                up += 1;
                if let Greater = tree.cmp(&forest[h][j]) {
                    continue;
                }
                break;
            }

            for h in (i + 1)..col_len {
                down += 1;
                if let Greater = tree.cmp(&forest[h][j]) {
                    continue;
                }
                break;
            }

            max_score = max(max_score, left * right * down * up)
        }
    }

    max_score
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let forest = parse_input(path)?;

    Ok((
        solution_1(&forest).to_string(),
        solution_2(&forest).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_commands() -> Vec<Vec<u8>> {
        parse_input("assets/d8test.txt").unwrap()
    }

    fn large_commands() -> Vec<Vec<u8>> {
        parse_input("assets/d8full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_commands()), 21);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_commands()), 8);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_commands()), 1_870);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_commands()), 517_440);
    }
}
