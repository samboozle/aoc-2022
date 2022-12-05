use crate::util::ParseError::{self, ReadError};
use std::collections::BTreeMap;
use std::fs;

type Crates = BTreeMap<u32, Vec<char>>;
type Instructions = Vec<(u32, u32, u32)>;

fn parse_input(path: &str) -> Result<(Crates, Instructions), ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        match s.split("\n\n").collect::<Vec<&str>>()[..] {
            [crates, instructions] => {
                let crates: Crates = crates
                    .split("\n")
                    .map(|line| line.chars().skip(1).step_by(4).collect())
                    .collect::<Vec<Vec<char>>>()
                    .into_iter()
                    .rev()
                    .skip(1)
                    .fold(Crates::new(), |mut c, row| {
                        for (i, item) in row.into_iter().enumerate() {
                            match item {
                                'A'..='Z' => c.entry((i as u32) + 1).or_insert(vec![]).push(item),
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
    move_crates_and_get_heads(crates, instructions, |stacks, (amount, from, to)| {
        for _ in 0..*amount {
            let mut push = None;

            stacks.entry(*from).and_modify(|e| push = e.pop());

            stacks.entry(*to).and_modify(|e| e.push(push.unwrap()));
        }
        stacks
    })
}

fn solution_2(crates: &mut Crates, instructions: &Instructions) -> String {
    move_crates_and_get_heads(crates, instructions, |stacks, (amount, from, to)| {
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
}

fn move_crates_and_get_heads<F>(crates: &mut Crates, instructions: &Instructions, fun: F) -> String
where
    F: for<'a> FnMut(&'a mut Crates, &'a (u32, u32, u32)) -> &'a mut Crates,
{
    instructions
        .into_iter()
        .fold(crates, fun)
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

    fn small_crates_and_instructions() -> (Crates, Instructions) {
        parse_input("assets/d5test.txt").unwrap()
    }

    fn large_crates_and_instructions() -> (Crates, Instructions) {
        parse_input("assets/d5full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        let (mut crates, instructions) = small_crates_and_instructions();
        assert_eq!(solution_1(&mut crates, &instructions), "CMZ".to_owned());
    }

    #[test]
    fn test_small_input_solution_2() {
        let (mut crates, instructions) = small_crates_and_instructions();
        assert_eq!(solution_2(&mut crates, &instructions), "MCD".to_owned());
    }

    #[test]
    fn test_large_input_solution_1() {
        let (mut crates, instructions) = large_crates_and_instructions();
        assert_eq!(
            solution_1(&mut crates, &instructions),
            "ZRLJGSCTR".to_owned()
        );
    }

    #[test]
    fn test_large_input_solution_2() {
        let (mut crates, instructions) = large_crates_and_instructions();
        assert_eq!(
            solution_2(&mut crates, &instructions),
            "PRTTGRFPB".to_owned()
        );
    }
}
