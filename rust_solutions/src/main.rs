mod solutions;

use solutions::*;

fn main() {
    let day_1_result = day_1::run("assets/d1full.txt");
    let day_2_result = day_2::run("assets/d2full.txt");

    println!("Day 1 answers: {:?}", day_1_result);
    println!("Day 2 answers: {:?}", day_2_result);
}
