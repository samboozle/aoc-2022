use crate::util::ParseError::{self, ReadError};
use std::collections::BTreeMap;
use std::fs;

type Crates = BTreeMap<u32, Vec<char>>;
type Instructions = Vec<(u32, u32, u32)>;

fn parse_input(path: &str) -> Result<(Crates, Instructions), ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        match s.split("\n\n").collect::<Vec<&str>>()[..] {
            [crates, instructions] => {
                let crates: Vec<Vec<char>> = crates
                    .split("\n")
                    .map(|line| line.chars().skip(1).step_by(4).collect())
                    .collect();

                let crates: Crates =
                    crates
                        .into_iter()
                        .rev()
                        .skip(1)
                        .fold(Crates::new(), |mut c, row| {
                            for (i, item) in row.into_iter().enumerate() {
                                match item {
                                    'A'..='Z' => {
                                        c.entry((i as u32) + 1).or_insert(vec![]).push(item)
                                    }
                                    _ => (),
                                }
                            }
                            c
                        });

                let instructions: Instructions = instructions
                    .split("\n")
                    .filter_map(|line| {
                        match line
                            .split_whitespace()
                            .filter_map(|n_str| match n_str.parse::<u32>() {
                                Ok(n) => Some(n),
                                _ => None,
                            })
                            .collect::<Vec<u32>>()[..]
                        {
                            [a, b, c] => Some((a, b, c)),
                            _ => None,
                        }
                    })
                    .collect();

                Ok((crates, instructions))
            }
            _ => Err(ParseError::ParseError),
        }
    } else {
        Err(ReadError)
    }
}

fn solution_1(crates: &mut Crates, instructions: &Instructions) -> String {
    instructions
        .into_iter()
        .fold(crates, |stacks, (amount, from, to)| {
            for _ in 0..*amount {
                let mut push: char = ' ';

                stacks.entry(*from).and_modify(|e| push = e.pop().unwrap());

                stacks.entry(*to).and_modify(|e| e.push(push));
            }
            stacks
        })
        .values()
        .fold(String::new(), |mut string, vals| {
            string.push(*vals.last().unwrap());
            string
        })
}

fn solution_2(crates: &mut Crates, instructions: &Instructions) -> String {
    instructions
        .into_iter()
        .fold(crates, |stacks, (amount, from, to)| {
            let mut push = vec![];

            stacks.entry(*from).and_modify(|e| {
                for _ in 0..*amount {
                    push.push(e.pop().unwrap());
                }
            });

            stacks.entry(*to).and_modify(|e| {
                while let Some(item) = push.pop() {
                    e.push(item);
                }
            });

            stacks
        })
        .values()
        .fold(String::new(), |mut string, vals| {
            string.push(*vals.last().unwrap());
            string
        })
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let (mut crates, instructions) = parse_input(path)?;
    let mut crates_clone = crates.clone();

    Ok((
        solution_1(&mut crates, &instructions),
        solution_2(&mut crates_clone, &instructions),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn crates_and_ops() -> (Crates, Instructions) {
        parse_input("assets/d5test.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        let (mut crates, instructions) = crates_and_ops();
        assert_eq!(solution_1(&mut crates, &instructions), "CMZ".to_owned());
    }

    #[test]
    fn test_small_input_solution_2() {
        let (mut crates, instructions) = crates_and_ops();
        assert_eq!(solution_2(&mut crates, &instructions), "MCD".to_owned());
    }
}
