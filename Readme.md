# Benchmark of performance (Dlang edition)

### Try to compare the performance of D code with others based on problems from benchmarkgames

Initially the idea comes from one popular benchmark repository, which compares different implementations on several languages for some well-known problems: https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html

However maintainer of the repository decides to support in his environment only a small set of popular languages .

After that another similar web-site was published: https://programming-language-benchmarks.vercel.app/

It has almost the same problems, but with much larger number of supported languages, including **zig**, **crystal**, **nim**, **d**, **v** (and many others).

This repository tries to find how **Dlang** is performing on such problems.



## Repository structure

* ### BinaryTree problem

  * https://programming-language-benchmarks.vercel.app/problem/binarytrees
  * D implementation v1 based on Crystal

* ### Edigits problem

  * https://programming-language-benchmarks.vercel.app/problem/edigits
  * D implementation v1 based on Crystal
  
* ### LRU problem

  * https://programming-language-benchmarks.vercel.app/problem/edigits
  * D implementation v1 based on Crystal

## Additional info

### Why Crystal?

Crystal uses quite simple implementation without any "hacks" with memory-allocations and multi-threading/multi-processing and shows a good result.

### Compiling flags and options

For Crystal compilation used:

`crystal build -release {filename}`

For DMD compilation used:

`dmd -release {filename}`

For LDC compilation used:

`ldc2 -O5 -release {filename}`

### Tool for time measurement

To benchmark executable files used **hyperfine** tool - which run each code several times and accurately find mean and std dev of running.

To use this tools just write run like that:
`hyperfine "bin/crystal_out 16" "python source/python.py 16" "bin/ldc_out 16" "bin/dmd_out 16" > out.txt`



## TODO

- Java-world code will be added (Java, Scala, Groovy, Kotlin)
- Compare D implementation with Fork:GC
- Try to find out why D works so slowly and find the way to boost the performance
- Submit PR to the initial repo with great D implementation

## Contribution

As always contribution is welcomed :)
