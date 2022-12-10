use crate::util::ParseError::{self, ReadError};
use std::{fs, ops::Rem};

enum Signal {
    Add(i32),
    Noop,
}

use Signal::*;

fn parse_input(path: &str) -> Result<Vec<Signal>, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let signals = s
            .trim()
            .split("\n")
            .filter_map(
                |line| match line.split_whitespace().collect::<Vec<&str>>()[..] {
                    [_, value] => match value.parse::<i32>() {
                        Ok(n) => Some(Add(n)),
                        _ => None,
                    },
                    [_] => Some(Noop),
                    _ => None,
                },
            )
            .collect::<Vec<Signal>>();

        Ok(signals)
    } else {
        Err(ReadError)
    }
}

fn solution_1(signals: &Vec<Signal>) -> i32 {
    signals
        .into_iter()
        .fold((0, 1, 0), |(sum, reg, cyc), signal| match signal {
            Noop => match cyc + 1 {
                20 | 60 | 100 | 140 | 180 | 220 => (sum + reg * (cyc + 1), reg, cyc + 1),
                c => (sum, reg, c),
            },
            Add(val) => match cyc + 2 {
                20 | 60 | 100 | 140 | 180 | 220 => (sum + reg * (cyc + 2), reg + val, cyc + 2),
                21 | 61 | 111 | 141 | 181 | 221 => (sum + reg * (cyc + 1), reg + val, cyc + 2),
                c => (sum, reg + val, c),
            },
        })
        .0
}

fn solution_2(signals: &Vec<Signal>) -> Vec<String> {
    signals
        .into_iter()
        .fold(
            (vec![String::new(); 6], 1i32, 0usize),
            |(mut crt, reg, cyc), signal| {
                let (lo, hi) = (reg - 1, reg + 1);

                let mut push = |offset: usize| match (cyc + offset).rem(40) as i32 {
                    x if x >= lo && x <= hi => crt[(cyc + offset) / 40].push('#'),
                    _ => crt[(cyc + offset) / 40].push('.'),
                };

                match (signal, cyc) {
                    (Noop, 0..=239) => {
                        push(0);
                        (crt, reg, cyc + 1)
                    }
                    (Add(val), 0..=239) => {
                        push(0);
                        push(1);
                        (crt, reg as i32 + val, cyc + 2)
                    }
                    _ => (crt, reg, cyc),
                }
            },
        )
        .0
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let motions = parse_input(path)?;

    Ok((
        solution_1(&motions).to_string(),
        solution_2(&motions).join("\n").to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_commands() -> Vec<Signal> {
        parse_input("assets/d10test.txt").unwrap()
    }

    fn medium_commands() -> Vec<Signal> {
        parse_input("assets/d10test-2.txt").unwrap()
    }

    fn large_commands() -> Vec<Signal> {
        parse_input("assets/d10full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_commands()), 0);
    }

    #[test]
    fn test_medium_input_solution_1() {
        assert_eq!(solution_1(&medium_commands()), 13_140);
    }

    #[test]
    fn test_medium_input_solution_2() {
        assert_eq!(
            solution_2(&medium_commands()).join("\n"),
            vec![
                "##..##..##..##..##..##..##..##..##..##..",
                "###...###...###...###...###...###...###.",
                "####....####....####....####....####....",
                "#####.....#####.....#####.....#####.....",
                "######......######......######......####",
                "#######.......#######.......#######.....",
            ]
            .join("\n")
        );
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_commands()), 12_540);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(
            solution_2(&large_commands()).join("\n"),
            vec![
                "####.####..##..####.####.#....#..#.####.",
                "#....#....#..#....#.#....#....#..#.#....",
                "###..###..#......#..###..#....####.###..",
                "#....#....#.....#...#....#....#..#.#....",
                "#....#....#..#.#....#....#....#..#.#....",
                "#....####..##..####.####.####.#..#.####."
            ]
            .join("\n")
        );
    }
}
