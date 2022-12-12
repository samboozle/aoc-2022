use crate::util::ParseError::{self, ReadError};
use std::{collections::HashSet, fs};

type Maze = (Vec<Vec<u8>>, (usize, usize), (usize, usize));

fn parse_input(path: &str) -> Result<Maze, ParseError> {
    if let Ok(s) = fs::read_to_string(path) {
        match s.trim().split_whitespace().enumerate().fold(
            (vec![], None, None),
            |(mut height_map, start, end), (row, line)| {
                let (chars, s, e) = line.char_indices().fold(
                    (vec![], start, end),
                    |(mut chars, s, e), (col, rune)| {
                        chars.push(rune as u8);
                        match rune {
                            'S' => (chars, Some((row, col)), e),
                            'E' => (chars, s, Some((row, col))),
                            _ch => (chars, s, e),
                        }
                    },
                );
                height_map.push(chars);
                (height_map, s, e)
            },
        ) {
            (height_map, Some(start), Some(end)) => Ok((height_map, start, end)),
            _ => Err(ParseError::ParseError),
        }
    } else {
        Err(ReadError)
    }
}

fn get_in(map: &Vec<Vec<u8>>, (x, y): (usize, usize)) -> Option<&u8> {
    map.get(x).and_then(|row| row.get(y))
}

fn neighbors((x, y): (usize, usize)) -> Vec<(usize, usize)> {
    let mut res = vec![(x + 1, y), (x, y + 1)];

    if let Some(x_) = x.checked_sub(1) {
        res.push((x_, y));
    }

    if let Some(y_) = y.checked_sub(1) {
        res.push((x, y_));
    }

    res
}

fn traverse_map<F>(map: &Vec<Vec<u8>>, start: (usize, usize), target: u8, fun: F) -> usize
where
    F: Fn(u8, u8) -> bool,
{
    let mut to_visit = HashSet::from([start]);
    let mut visited = HashSet::new();
    let mut depth = 1;

    while !to_visit.is_empty() {
        let mut visit_next = HashSet::new();

        for node in to_visit.drain() {
            if let Some(here) = get_in(map, node) {
                for neighbor in neighbors(node) {
                    if !visited.contains(&neighbor) {
                        if let Some(there) = get_in(map, neighbor) {
                            match (fun(*here, *there), *there == target) {
                                (true, true) => return depth,
                                (true, false) => visit_next.insert(neighbor),
                                (_, _) => false,
                            };
                        }
                    }
                }

                visited.insert(node);
            }
        }

        to_visit = visit_next;

        depth += 1;
    }

    depth
}

fn check_neighbor(a: u8, b: u8) -> bool {
    match (a, b) {
        (83, 97 | 98) | (121 | 122, 69) => true,
        (_, 69) => false,
        (here, there) => there <= here + 1,
    }
}

fn solution_1(height_map: &Vec<Vec<u8>>, start: (usize, usize)) -> usize {
    // Start at (x, y) such that height_map[x][y] == 'S'
    traverse_map(height_map, start, 69, check_neighbor)
}

fn solution_2(height_map: &Vec<Vec<u8>>, end: (usize, usize)) -> usize {
    // Start at (x, y) such that height_map[x][y] == 'E'
    // BFS for 'a'
    traverse_map(height_map, end, 97, |a, b| check_neighbor(b, a))
}

pub fn run(path: &str) -> Result<(String, String), ParseError> {
    let (height_map, start, end) = parse_input(path)?;

    Ok((
        solution_1(&height_map, start).to_string(),
        solution_2(&height_map, end).to_string(),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn small_maze() -> Maze {
        parse_input("assets/d12test.txt").unwrap()
    }

    fn large_maze() -> Maze {
        parse_input("assets/d12full.txt").unwrap()
    }

    #[test]
    fn test_small_input_solution_1() {
        let (height_map, start, _) = small_maze();
        assert_eq!(solution_1(&height_map, start), 31);
    }

    #[test]
    fn test_large_input_solution_1() {
        let (height_map, start, _) = large_maze();
        assert_eq!(solution_1(&height_map, start), 440);
    }

    #[test]
    fn test_small_input_solution_2() {
        let (height_map, _, end) = small_maze();
        assert_eq!(solution_2(&height_map, end), 29);
    }

    #[test]
    fn test_large_input_solution_2() {
        let (height_map, _, end) = large_maze();
        assert_eq!(solution_2(&height_map, end), 439);
    }
}
