import pandas as pd
from timeit import default_timer as timer

start = timer()
print(lhs.corr(rhs, method="kendall"))
end = timer()
print(f"Correlation computation takes={1000*(end - start)} milli-seconds")
