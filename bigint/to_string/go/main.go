package main

import (
    "fmt"
    "math/big"
    "time"
)

const N = 10_000

func main() {
    time_start := time.Now()
    a, b, sum := big.NewInt(0), big.NewInt(1), big.NewInt(0)

    for n := 2; n <= N-1; n++ {
        sum.Add(a, b)
        fmt.Printf("%d\t%s\n", n, sum)
        a.Set(b)
        b.Set(sum)
    }

    fmt.Printf("\nTotal Time = %d ms\n", time.Since(time_start).Milliseconds())
}
