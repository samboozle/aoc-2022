mod solutions;
mod util;

use solutions::*;

fn main() {
    [day_1::run, day_2::run, day_3::run, day_4::run, day_5::run]
        .iter()
        .enumerate()
        .for_each(
            |(day, fun)| match fun(format!("assets/d{}full.txt", day + 1).as_str()) {
                Ok((sol1, sol2)) => {
                    println!(
                        "\nDay {} solutions:\n    Part 1: {}\n    Part 2: {}\n",
                        day + 1,
                        sol1,
                        sol2
                    );
                }
                _ => (),
            },
        );
}
