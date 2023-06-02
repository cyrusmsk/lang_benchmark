import numpy as np
import scipy.stats as sps
from timeit import default_timer as timer

start = timer()
print(sps.kendalltau(lhs, rhs))
end = timer()
print(f"Correlation computation takes={1000*(end - start)} milli-seconds")
