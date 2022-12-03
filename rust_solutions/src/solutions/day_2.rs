use std::cmp::Ordering;
use std::fs;
use std::str::FromStr;

#[derive(PartialEq, Eq, Clone, Copy)]
enum Signal {
    A,
    B,
    C,
    X,
    Y,
    Z,
}

#[derive(PartialEq, Eq)]
enum Move {
    Rock = 1,
    Paper = 2,
    Scissors = 3,
}

impl Move {
    fn beats(&self) -> Move {
        match self {
            Rock => Scissors,
            Paper => Rock,
            Scissors => Paper,
        }
    }

    fn loses_to(&self) -> Move {
        match self {
            Rock => Paper,
            Paper => Scissors,
            Scissors => Rock,
        }
    }
}

enum Outcome {
    Win = 6,
    Draw = 3,
    Lose = 0,
}

use Move::*;
use Ordering::*;
use Outcome::*;
use Signal::*;

impl Signal {
    fn to_move(self) -> Move {
        match self {
            A | X => Rock,
            B | Y => Paper,
            C | Z => Scissors,
        }
    }

    fn to_outcome(self) -> Option<Outcome> {
        match self {
            X => Some(Lose),
            Y => Some(Draw),
            Z => Some(Win),
            _ => None,
        }
    }
}

impl FromStr for Signal {
    type Err = ();

    fn from_str(s: &str) -> Result<Signal, Self::Err> {
        match s {
            "A" => Ok(A),
            "B" => Ok(B),
            "C" => Ok(C),
            "X" => Ok(X),
            "Y" => Ok(Y),
            "Z" => Ok(Z),
            _ => Err(()),
        }
    }
}

impl PartialOrd for Move {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        match (self, other) {
            (Rock, Scissors) => Some(Ordering::Greater),
            (Scissors, Paper) => Some(Ordering::Greater),
            (Paper, Rock) => Some(Ordering::Greater),
            (a, b) if a == b => Some(Ordering::Equal),
            _ => Some(Ordering::Less),
        }
    }
}

#[derive(PartialEq, Eq)]
pub struct Frame(Signal, Signal);

impl Frame {
    fn to_find_outcome(&self) -> Turn {
        let Frame(a, b) = self;
        Turn::FindOutcome(a.to_move(), b.to_move())
    }

    fn to_find_move(&self) -> Turn {
        let Frame(a, b) = self;
        Turn::FindMove(a.to_move(), b.to_outcome().unwrap())
    }
}

enum Turn {
    FindMove(Move, Outcome),
    FindOutcome(Move, Move),
}

impl Turn {
    fn play(self) -> (Outcome, Move) {
        match self {
            Turn::FindOutcome(a, b) => match b.partial_cmp(&a).unwrap() {
                Greater => (Win, b),
                Equal => (Draw, b),
                Less => (Lose, b),
            },
            Turn::FindMove(a, b) => match b {
                Win => (Win, a.loses_to()),
                Draw => (Draw, a),
                Lose => (Lose, a.beats()),
            },
        }
    }
}

pub fn parse_input(path: &str) -> Result<Vec<Frame>, std::io::Error> {
    let s = fs::read_to_string(path)?;

    let turns = s.split("\n").into_iter().fold(vec![], |mut acc, line| {
        match line
            .split_whitespace()
            .filter_map(|move_str| match Signal::from_str(move_str) {
                Ok(sig) => Some(sig),
                _ => None,
            })
            .collect::<Vec<Signal>>()[..]
        {
            [a, b] => acc.push(Frame(a, b)),
            _ => (),
        };

        acc
    });

    Ok(turns)
}

pub fn solution_1(turns: &Vec<Frame>) -> u32 {
    turns.into_iter().fold(0, |acc, frame| {
        let (outcome, r#move) = frame.to_find_outcome().play();
        acc + (outcome as u32) + (r#move as u32)
    })
}

pub fn solution_2(turns: &Vec<Frame>) -> u32 {
    turns.into_iter().fold(0, |acc, frame| {
        let (outcome, r#move) = frame.to_find_move().play();
        acc + (outcome as u32) + (r#move as u32)
    })
}

pub fn run(path: &str) -> Result<(u32, u32), std::io::Error> {
    let frames = parse_input(path)?;

    let answer_1 = solution_1(&frames);
    let answer_2 = solution_2(&frames);

    Ok((answer_1, answer_2))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn frames() -> Vec<Frame> {
        parse_input("assets/d2test.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        assert_eq!(solution_1(&frames()), 15);
    }

    #[test]
    fn test_small_input_solution_2() {
        assert_eq!(solution_2(&frames()), 12);
    }
}
