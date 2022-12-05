use std::cmp::Ordering;

pub fn desc<T: Ord>(a: &T, b: &T) -> Ordering {
    b.cmp(a)
}

#[derive(Debug)]
pub enum ParseError {
    ReadError,
    ParseError,
}
