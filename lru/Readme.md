Benchmark 1: pypy3 ../source/py_code.py 1000000 10
  Time (mean ± σ):     225.4 ms ±  16.7 ms    [User: 202.5 ms, System: 21.2 ms]
  Range (min … max):   207.4 ms … 259.4 ms    12 runs
 
Benchmark 2: ./cr_array 1000000 10
  Time (mean ± σ):      33.9 ms ±  11.2 ms    [User: 32.7 ms, System: 3.9 ms]
  Range (min … max):    13.5 ms …  46.7 ms    159 runs
 
Benchmark 3: ./cr_hash 1000000 10
  Time (mean ± σ):      94.3 ms ±  14.1 ms    [User: 93.2 ms, System: 4.0 ms]
  Range (min … max):    70.2 ms … 110.0 ms    37 runs
 
Benchmark 4: ./d_hash 1000000 10
  Time (mean ± σ):      99.7 ms ±  13.5 ms    [User: 97.9 ms, System: 2.1 ms]
  Range (min … max):    85.0 ms … 117.6 ms    30 runs
 
Benchmark 5: ./d_array 1000000 10
  Time (mean ± σ):      41.6 ms ±  11.8 ms    [User: 39.9 ms, System: 2.0 ms]
  Range (min … max):    19.9 ms …  53.4 ms    108 runs
 
Summary
  './cr_array 1000000 10' ran
    1.23 ± 0.53 times faster than './d_array 1000000 10'
    2.78 ± 1.01 times faster than './cr_hash 1000000 10'
    2.94 ± 1.05 times faster than './d_hash 1000000 10'
    6.64 ± 2.25 times faster than 'pypy3 ../source/py_code.py 1000000 10'
---
Benchmark 1: pypy3 ../source/py_code.py 1000000 1000
  Time (mean ± σ):     204.7 ms ±  18.8 ms    [User: 178.3 ms, System: 20.5 ms]
  Range (min … max):   176.1 ms … 233.5 ms    16 runs
 
Benchmark 2: ./cr_array 1000000 1000
  Time (mean ± σ):      89.9 ms ±  13.3 ms    [User: 89.3 ms, System: 3.2 ms]
  Range (min … max):    71.8 ms … 112.9 ms    38 runs
 
Benchmark 3: ./cr_hash 1000000 1000
  Time (mean ± σ):     147.1 ms ±  10.7 ms    [User: 146.5 ms, System: 3.3 ms]
  Range (min … max):   127.9 ms … 162.6 ms    19 runs
 
Benchmark 4: ./d_hash 1000000 1000
  Time (mean ± σ):     161.4 ms ±  12.4 ms    [User: 159.7 ms, System: 1.6 ms]
  Range (min … max):   145.0 ms … 177.7 ms    19 runs
 
Benchmark 5: ./d_array 1000000 1000
  Time (mean ± σ):     177.0 ms ±  13.0 ms    [User: 174.8 ms, System: 2.2 ms]
  Range (min … max):   158.1 ms … 190.4 ms    15 runs
 
Summary
  './cr_array 1000000 1000' ran
    1.64 ± 0.27 times faster than './cr_hash 1000000 1000'
    1.80 ± 0.30 times faster than './d_hash 1000000 1000'
    1.97 ± 0.32 times faster than './d_array 1000000 1000'
    2.28 ± 0.40 times faster than 'pypy3 ../source/py_code.py 1000000 1000'
---
Benchmark 1: pypy3 ../source/py_code.py 5000000 10
  Time (mean ± σ):     572.4 ms ±  19.7 ms    [User: 541.8 ms, System: 21.7 ms]
  Range (min … max):   549.7 ms … 606.3 ms    10 runs
 
Benchmark 2: ./cr_array 5000000 10
  Time (mean ± σ):      89.8 ms ±  14.2 ms    [User: 88.8 ms, System: 3.7 ms]
  Range (min … max):    69.3 ms … 117.4 ms    38 runs
 
Benchmark 3: ./cr_hash 5000000 10
  Time (mean ± σ):     389.3 ms ±  15.6 ms    [User: 385.8 ms, System: 6.1 ms]
  Range (min … max):   367.0 ms … 411.9 ms    10 runs
 
Benchmark 4: ./d_hash 5000000 10
  Time (mean ± σ):     435.0 ms ±  13.4 ms    [User: 433.6 ms, System: 1.2 ms]
  Range (min … max):   420.0 ms … 449.8 ms    10 runs
 
Benchmark 5: ./d_array 5000000 10
  Time (mean ± σ):     114.7 ms ±  13.6 ms    [User: 113.3 ms, System: 1.7 ms]
  Range (min … max):    98.8 ms … 130.9 ms    22 runs
 
Summary
  './cr_array 5000000 10' ran
    1.28 ± 0.25 times faster than './d_array 5000000 10'
    4.34 ± 0.71 times faster than './cr_hash 5000000 10'
    4.85 ± 0.78 times faster than './d_hash 5000000 10'
    6.38 ± 1.03 times faster than 'pypy3 ../source/py_code.py 5000000 10'

---
Benchmark 1: pypy3 ../source/py_code.py 5000000 1000
  Time (mean ± σ):     565.7 ms ±  15.5 ms    [User: 528.5 ms, System: 22.3 ms]
  Range (min … max):   548.5 ms … 583.7 ms    10 runs
 
Benchmark 2: ./cr_array 5000000 1000
  Time (mean ± σ):     378.3 ms ±  13.0 ms    [User: 376.9 ms, System: 4.5 ms]
  Range (min … max):   355.1 ms … 389.5 ms    10 runs
 
Benchmark 3: ./cr_hash 5000000 1000
  Time (mean ± σ):     669.5 ms ±  27.3 ms    [User: 667.8 ms, System: 3.9 ms]
  Range (min … max):   622.8 ms … 704.1 ms    10 runs
 
Benchmark 4: ./d_hash 5000000 1000
  Time (mean ± σ):     741.9 ms ±  12.2 ms    [User: 739.1 ms, System: 2.4 ms]
  Range (min … max):   723.7 ms … 759.3 ms    10 runs
 
Benchmark 5: ./d_array 5000000 1000
  Time (mean ± σ):     799.2 ms ±  12.3 ms    [User: 795.3 ms, System: 2.8 ms]
  Range (min … max):   784.5 ms … 817.9 ms    10 runs
 
Summary
  './cr_array 5000000 1000' ran
    1.50 ± 0.07 times faster than 'pypy3 ../source/py_code.py 5000000 1000'
    1.77 ± 0.09 times faster than './cr_hash 5000000 1000'
    1.96 ± 0.07 times faster than './d_hash 5000000 1000'
    2.11 ± 0.08 times faster than './d_array 5000000 1000'
---
Benchmark 1: pypy3 ../source/py_code.py 10000000 10
  Time (mean ± σ):      1.018 s ±  0.023 s    [User: 0.974 s, System: 0.029 s]
  Range (min … max):    0.988 s …  1.067 s    10 runs
 
Benchmark 2: ./cr_array 10000000 10
  Time (mean ± σ):     157.8 ms ±  12.9 ms    [User: 156.6 ms, System: 3.8 ms]
  Range (min … max):   136.8 ms … 173.9 ms    20 runs
 
Benchmark 3: ./cr_hash 10000000 10
  Time (mean ± σ):     750.4 ms ±  16.6 ms    [User: 747.9 ms, System: 5.1 ms]
  Range (min … max):   728.8 ms … 778.5 ms    10 runs
 
Benchmark 4: ./d_hash 10000000 10
  Time (mean ± σ):     860.6 ms ±  10.5 ms    [User: 858.6 ms, System: 2.0 ms]
  Range (min … max):   842.0 ms … 872.6 ms    10 runs
 
Benchmark 5: ./d_array 10000000 10
  Time (mean ± σ):     216.5 ms ±  12.7 ms    [User: 214.3 ms, System: 2.2 ms]
  Range (min … max):   198.1 ms … 227.8 ms    14 runs
 
Summary
  './cr_array 10000000 10' ran
    1.37 ± 0.14 times faster than './d_array 10000000 10'
    4.75 ± 0.40 times faster than './cr_hash 10000000 10'
    5.45 ± 0.45 times faster than './d_hash 10000000 10'
    6.45 ± 0.54 times faster than 'pypy3 ../source/py_code.py 10000000 10'

---
Benchmark 1: pypy3 ../source/py_code.py 10000000 1000
  Time (mean ± σ):      1.015 s ±  0.016 s    [User: 0.974 s, System: 0.026 s]
  Range (min … max):    0.992 s …  1.038 s    10 runs
 
Benchmark 2: ./cr_array 10000000 1000
  Time (mean ± σ):     728.9 ms ±  12.7 ms    [User: 728.3 ms, System: 2.4 ms]
  Range (min … max):   710.1 ms … 748.3 ms    10 runs
 
Benchmark 3: ./cr_hash 10000000 1000
  Time (mean ± σ):      1.319 s ±  0.028 s    [User: 1.317 s, System: 0.004 s]
  Range (min … max):    1.283 s …  1.379 s    10 runs
 
Benchmark 4: ./d_hash 10000000 1000
  Time (mean ± σ):      1.462 s ±  0.023 s    [User: 1.456 s, System: 0.001 s]
  Range (min … max):    1.429 s …  1.494 s    10 runs
 
Benchmark 5: ./d_array 10000000 1000
  Time (mean ± σ):      1.583 s ±  0.014 s    [User: 1.577 s, System: 0.001 s]
  Range (min … max):    1.570 s …  1.606 s    10 runs
 
Summary
  './cr_array 10000000 1000' ran
    1.39 ± 0.03 times faster than 'pypy3 ../source/py_code.py 10000000 1000'
    1.81 ± 0.05 times faster than './cr_hash 10000000 1000'
    2.01 ± 0.05 times faster than './d_hash 10000000 1000'
    2.17 ± 0.04 times faster than './d_array 10000000 1000'

