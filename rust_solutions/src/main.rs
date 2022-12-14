mod solutions;
mod util;

use solutions::*;

fn main() {
    [
        day_01::run,
        day_02::run,
        day_03::run,
        day_04::run,
        day_05::run,
        day_06::run,
        day_07::run,
        day_08::run,
        day_09::run,
        day_10::run,
        day_11::run,
        day_12::run,
        day_13::run,
    ]
    .iter()
    .enumerate()
    .for_each(
        |(day, fun)| match fun(format!("assets/d{}full.txt", day + 1).as_str()) {
            Ok((sol1, sol2)) => {
                println!(
                    "\nDay {} solutions:\n    Part 1: {}\n    Part 2: {}{}\n",
                    day + 1,
                    sol1,
                    match day {
                        9 => "below...\n\n",
                        _ => "",
                    },
                    sol2
                );
            }
            _ => (),
        },
    );
}
