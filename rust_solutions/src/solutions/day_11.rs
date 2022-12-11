use crate::util::ParseError::{self, ReadError};
use std::fs;
use std::ops::Rem;

#[derive(Debug, Clone)]
enum Operation {
    Add(u64),
    Sub(u64),
    Mul(u64),
    Dub,
    Sqr,
}

impl Operation {
    fn from_str(op: &str) -> Option<Self> {
        match op.split_whitespace().collect::<Vec<&str>>()[..] {
            ["+", "old"] => Some(Dub),
            ["*", "old"] => Some(Sqr),
            ["+", x] => match x.parse::<u64>() {
                Ok(n) => Some(Add(n)),
                _ => None,
            },
            ["-", x] => match x.parse::<u64>() {
                Ok(n) => Some(Sub(n)),
                _ => None,
            },
            ["*", x] => match x.parse::<u64>() {
                Ok(n) => Some(Mul(n)),
                _ => None,
            },
            _ => None,
        }
    }
}

use Operation::*;

#[derive(Debug, Clone)]
struct Monkey {
    items: Vec<u64>,
    inspections: u64,
    operation: Operation,
    test: u64,
    targets: (usize, usize),
}

impl Monkey {
    fn new() -> Self {
        Monkey {
            items: vec![],
            inspections: 0,
            operation: Add(0),
            test: 1,
            targets: (0, 0),
        }
    }
}

type Barrel = Vec<Monkey>;

fn parse_input(path: &str) -> Result<Barrel, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let barrel = s
            .trim()
            .split("\n\n")
            .filter_map(|monkey_profile| {
                monkey_profile
                    .split("\n")
                    .into_iter()
                    .skip(1)
                    .enumerate()
                    .try_fold(Monkey::new(), |mut monkey, (idx, line)| match idx {
                        0 => {
                            for item in line.trim().splitn(3, ' ').last().unwrap().split(", ") {
                                if let Ok(n) = item.parse::<u64>() {
                                    monkey.items.push(n);
                                }
                            }
                            Some(monkey)
                        }
                        1 => {
                            match line
                                .trim()
                                .splitn(5, ' ')
                                .last()
                                .map(|op| Operation::from_str(op))
                            {
                                Some(Some(op)) => {
                                    monkey.operation = op;
                                    Some(monkey)
                                }
                                _ => None,
                            }
                        }
                        2 => {
                            match line
                                .trim()
                                .split_whitespace()
                                .last()
                                .map(|n| n.parse::<u64>())
                            {
                                Some(Ok(n)) => {
                                    monkey.test = n;
                                    Some(monkey)
                                }
                                _ => None,
                            }
                        }
                        3 => {
                            match line
                                .trim()
                                .split_whitespace()
                                .last()
                                .map(|n| n.parse::<usize>())
                            {
                                Some(Ok(n)) => {
                                    monkey.targets.0 = n;
                                    Some(monkey)
                                }
                                _ => None,
                            }
                        }
                        4 => {
                            match line
                                .trim()
                                .split_whitespace()
                                .last()
                                .map(|n| n.parse::<usize>())
                            {
                                Some(Ok(n)) => {
                                    monkey.targets.1 = n;
                                    Some(monkey)
                                }
                                _ => None,
                            }
                        }
                        _ => Some(monkey),
                    })
            })
            .collect::<Barrel>();

        Ok(barrel)
    } else {
        Err(ReadError)
    }
}

fn simulate_monkey_business(mut barrel: Barrel, rounds: usize, throttle: u64) -> u64 {
    let lcm = barrel.iter().fold(1, |acc, monkey| monkey.test * acc);

    for _ in 0..rounds {
        for i in 0..barrel.len() {
            let mut trues = vec![];
            let mut falses = vec![];
            let (t, f) = barrel[i].targets.clone();

            {
                let monkey = &mut barrel[i];
                for worry in &monkey.items {
                    monkey.inspections += 1;

                    let new_worry = match monkey.operation {
                        Add(n) => ((worry + n) / throttle).rem_euclid(lcm),
                        Sub(n) => ((worry - n) / throttle).rem_euclid(lcm),
                        Mul(n) => ((worry * n) / throttle).rem_euclid(lcm),
                        Dub => ((worry + worry) / throttle).rem_euclid(lcm),
                        Sqr => ((worry * worry) / throttle).rem_euclid(lcm),
                    };

                    match new_worry.rem(monkey.test) {
                        0 => trues.push(new_worry),
                        _ => falses.push(new_worry),
                    }
                }
                monkey.items.clear();
            }

            {
                let monkey = &mut barrel[t];
                for item in trues {
                    monkey.items.push(item);
                }
            }

            {
                let monkey = &mut barrel[f];
                for item in falses {
                    monkey.items.push(item);
                }
            }
        }
    }

    barrel.sort_by(|monk_a, monk_b| monk_b.inspections.cmp(&monk_a.inspections));

    barrel
        .iter()
        .take(2)
        .fold(1, |acc, monkey| acc * monkey.inspections)
}

fn solution_1(barrel: Barrel) -> u64 {
    simulate_monkey_business(barrel, 20, 3)
}

fn solution_2(barrel: Barrel) -> u64 {
    simulate_monkey_business(barrel, 10_000, 1)
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let barrel = parse_input(path)?;
    let barrel_1 = barrel.clone();

    Ok((
        solution_1(barrel).to_string(),
        solution_2(barrel_1).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_monkeys() -> Barrel {
        parse_input("assets/d11test.txt").unwrap()
    }

    fn large_monkeys() -> Barrel {
        parse_input("assets/d11full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(small_monkeys()), 10_605);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(large_monkeys()), 56_120);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(small_monkeys()), 2_713_310_158);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(large_monkeys()), 24_389_045_529);
    }
}
