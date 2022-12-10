use crate::util::ParseError::{self, ReadError};
use std::collections::HashMap;
use std::fs;

const THRESHOLD: u32 = 40_000_000;

fn parse_input(path: &str) -> Result<Vec<String>, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        let commands = s.split("\n").map(|line| line.to_owned()).collect();
        Ok(commands)
    } else {
        Err(ReadError)
    }
}

fn solution_1(commands: &Vec<String>) -> u32 {
    directory_flat(commands)
        .into_iter()
        .fold(0, |acc, (_, el)| if el <= 100_000 { acc + el } else { acc })
}

fn solution_2(commands: &Vec<String>) -> u32 {
    let dir = directory_flat(commands);
    let occupied = dir.get(&String::from("/root")).unwrap();

    *dir.values()
        .filter(|size| occupied - *size < THRESHOLD)
        .min()
        .unwrap_or(&occupied)
}

fn directory_flat(commands: &Vec<String>) -> HashMap<String, u32> {
    commands
        .iter()
        .fold(
            (vec![], HashMap::new()),
            |(mut breadcrumb, mut flattened), command| {
                let cmd: Vec<&str> = command.split_whitespace().collect();
                match cmd[..] {
                    ["$", "cd", "/"] => breadcrumb = vec!["root"],
                    ["$", "cd", ".."] => {
                        breadcrumb.pop();
                    }
                    ["$", "cd", dir] => breadcrumb.push(dir),
                    ["$", "ls"] => (),
                    ["dir", _dir] => (),
                    [size, _file] => {
                        let size = size.parse::<u32>().unwrap();
                        let mut full_path = String::from("");

                        for dir in breadcrumb.iter() {
                            full_path += "/";
                            full_path += dir;
                            *flattened.entry(full_path.clone()).or_insert(0u32) += size;
                        }
                    }
                    _ => (),
                };

                (breadcrumb, flattened)
            },
        )
        .1
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let commands = parse_input(path)?;

    Ok((
        solution_1(&commands).to_string(),
        solution_2(&commands).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_commands() -> Vec<String> {
        parse_input("assets/d7test.txt").unwrap()
    }

    fn large_commands() -> Vec<String> {
        parse_input("assets/d7full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&small_commands()), 95_437);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&small_commands()), 24_933_642);
    }

    #[test]
    fn test_large_input_solution_1() {
        assert_eq!(solution_1(&large_commands()), 1_490_523);
    }

    #[test]
    fn test_large_input_solution_2() {
        assert_eq!(solution_2(&large_commands()), 12_390_492);
    }
}
