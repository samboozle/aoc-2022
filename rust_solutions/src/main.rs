mod solutions;

use solutions::*;

fn main() {
    [day_1::run, day_2::run, day_3::run, day_4::run]
        .iter()
        .enumerate()
        .for_each(
            |(i, f)| match f(format!("assets/d{}full.txt", i + 1).as_str()) {
                Ok((sol1, sol2)) => {
                    println!(
                        "\nDay {} solutions:\n    Part 1: {}\n    Part 2: {}\n",
                        i + 1,
                        sol1,
                        sol2
                    );
                }
                _ => (),
            },
        );
}
