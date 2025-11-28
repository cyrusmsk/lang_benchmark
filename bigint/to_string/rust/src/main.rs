use num::bigint::{BigUint, ToBigUint};
use num::traits::{Zero, One};
use std::time::Instant;

const N: usize = 10000;

fn main() {
    let time_start = Instant::now();
    let mut a = BigUint::zero();
    let mut b = BigUint::one();

    for n in 2..N {
        let sum = &a + &b;
        println!("{}\t{}", n, sum);
        a = b;
        b = sum;
    }

    let elapsed = time_start.elapsed().as_millis();
    println!("\nTotal Time = {} ms", elapsed);
}
