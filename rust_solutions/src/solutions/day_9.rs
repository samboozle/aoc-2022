use crate::util::ParseError::{self, ReadError};
use std::collections::HashSet;
use std::fs;

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug)]
struct Motion(Direction, i32);

use Direction::*;

fn parse_input(path: &str) -> Result<Vec<Motion>, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let motions = s
            .trim()
            .split("\n")
            .filter_map(
                |line| match line.split_whitespace().collect::<Vec<&str>>()[..] {
                    [motion, distance] => match (motion, distance.parse::<i32>()) {
                        ("U", Ok(n)) => Some(Motion(Up, n)),
                        ("D", Ok(n)) => Some(Motion(Down, n)),
                        ("L", Ok(n)) => Some(Motion(Left, n)),
                        ("R", Ok(n)) => Some(Motion(Right, n)),
                        _ => None,
                    },
                    _ => None,
                },
            )
            .collect::<Vec<Motion>>();

        Ok(motions)
    } else {
        Err(ReadError)
    }
}

fn solution_1(motions: &Vec<Motion>) -> usize {
    follow_reduce(motions, 1)
}

fn solution_2(motions: &Vec<Motion>) -> usize {
    follow_reduce(motions, 9)
}

fn move_head(head: (i32, i32), dir: &Direction) -> (i32, i32) {
    let (x, y) = head;
    match dir {
        Up => (x, y + 1),
        Down => (x, y - 1),
        Left => (x - 1, y),
        Right => (x + 1, y),
    }
}

fn follow((a, b): (i32, i32), tail @ (x, y): (i32, i32)) -> (i32, i32) {
    let diff = (a - x, b - y);

    match diff {
        (0, 2) => (x, y + 1),
        (0, -2) => (x, y - 1),
        (2, 0) => (x + 1, y),
        (-2, 0) => (x - 1, y),
        (1, 1) | (1, -1) | (-1, 1) | (-1, -1) => tail,
        (i, j) if i > 0 && j > 0 => (x + 1, y + 1),
        (i, j) if i < 0 && j < 0 => (x - 1, y - 1),
        (i, j) if i > 0 && j < 0 => (x + 1, y - 1),
        (i, j) if i < 0 && j > 0 => (x - 1, y + 1),
        _ => tail,
    }
}

fn follow_reduce(motions: &Vec<Motion>, rope_length: usize) -> usize {
    let init = (0, 0);

    let (tail_trail, _, _) = motions.into_iter().fold(
        (HashSet::<(i32, i32)>::new(), init, vec![init; rope_length]),
        |(mut trail, mut head, mut rope), Motion(dir, distance)| {
            for _ in 0..*distance {
                let mut leader = move_head(head, dir);
                head = leader;

                for i in 0..rope.len() {
                    leader = follow(leader, rope[i]);
                    rope[i] = leader;

                    if i == rope.len() - 1 {
                        trail.insert(leader);
                    }
                }
            }

            (trail, head, rope)
        },
    );

    tail_trail.len()
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

    fn small_commands() -> Vec<Motion> {
        parse_input("assets/d9test.txt").unwrap()
    }

    fn medium_commands() -> Vec<Motion> {
        parse_input("assets/d9test-2.txt").unwrap()
    }

    fn large_commands() -> Vec<Motion> {
        parse_input("assets/d9full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_commands()), 13);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_commands()), 1);
    }

    #[test]
    fn test_medium_input_solution_2() {
        assert_eq!(solution_2(&medium_commands()), 36);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_commands()), 6_311);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_commands()), 2_482);
    }
}
