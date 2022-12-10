use crate::util::ParseError::{self, ReadError};
use std::cmp::Ordering::{self, *};
use std::fs;

type RangePair = ((u32, u32), (u32, u32));

type RangePairs = Vec<RangePair>;

fn parse_input(path: &str) -> Result<RangePairs, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let rangepairs = s
            .split_whitespace()
            .into_iter()
            .filter_map(|pair| {
                match pair
                    .split(",")
                    .filter_map(|range| {
                        match range
                            .split("-")
                            .map(|n| n.parse::<u32>())
                            .collect::<Vec<Result<u32, _>>>()[..]
                        {
                            [Ok(lo), Ok(hi)] => match lo.cmp(&hi) {
                                // JIC - reverse any range written such that lo > hi
                                Greater => Some((hi, lo)),
                                _ => Some((lo, hi)),
                            },
                            _ => None,
                        }
                    })
                    .collect::<Vec<(u32, u32)>>()[..]
                {
                    [a, b] => Some((a, b)),
                    _ => None,
                }
            })
            .collect();

        Ok(rangepairs)
    } else {
        Err(ReadError)
    }
}

fn solution_1(rangepairs: &RangePairs) -> u32 {
    cmp_rangepairs(rangepairs, |((a, b), (x, y))| (a.cmp(&x), b.cmp(&y)))
}

fn solution_2(rangepairs: &RangePairs) -> u32 {
    cmp_rangepairs(rangepairs, |((a, b), (x, y))| (a.cmp(&y), b.cmp(&x)))
}

fn cmp_rangepairs<F>(rangepairs: &RangePairs, fun: F) -> u32
where
    F: Fn(RangePair) -> (Ordering, Ordering),
{
    rangepairs
        .into_iter()
        .fold(0, |acc, rangepair| match fun(*rangepair) {
            (Greater, Greater) | (Less, Less) => acc,
            _ => acc + 1,
        })
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let rangepairs = parse_input(path)?;

    let answer_1 = solution_1(&rangepairs);
    let answer_2 = solution_2(&rangepairs);

    Ok((answer_1.to_string(), answer_2.to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_rangepairs() -> RangePairs {
        parse_input("assets/d4test.txt").unwrap()
    }

    fn large_rangepairs() -> RangePairs {
        parse_input("assets/d4full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_rangepairs()), 2);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_rangepairs()), 4);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_rangepairs()), 431);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_rangepairs()), 823);
    }
}
