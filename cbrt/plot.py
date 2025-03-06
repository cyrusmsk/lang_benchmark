import matplotlib.pyplot as plt
import pandas as pd
import json
import pprint

# Load D data
def read_d(path, name, min_vec, mean_vec, max_vec):
    with open(path, "r") as d_json:
        d_dict = json.load(d_json)
        for calculation in d_dict:
            for func_type in calculation["BenchmarksResults"]:
                if func_type["name"] == name:
                    min_vec.append(func_type["ns_iter_summ"]["min"] / 1E+9)
                    mean_vec.append(func_type["ns_iter_summ"]["mean"] / 1E+9)
                    max_vec.append(func_type["ns_iter_summ"]["max"] / 1E+9)

d1_min = []
d1_mean = []
d1_max = []
d2_min = []
d2_mean = []
d2_max = []

small_range = [p*1000 for p in range(1, 11)]

read_d("regular_data.json", "test_sum_pow", d1_min, d1_mean, d1_max)
read_d("regular_data.json", "test_sum_cbrt", d2_min, d2_mean, d2_max)

d1 = pd.DataFrame({
        "min" : d1_min,
        "mean": d1_mean,
        "max" : d1_max,
    })

d2 = pd.DataFrame({
        "min" : d2_min,
        "mean": d2_mean,
        "max" : d2_max,
    })


# Filtering
d_pow = d1
d_cbrt = d2

# Prepare Plot
plt.figure(figsize=(10,6), dpi=300)
plt.title(r"Benchmark for cbrt", fontsize=16)
plt.xlabel(r'size', fontsize=14)
plt.ylabel(r'time(s)', fontsize=14)

domain = small_range

# Plot with Legends
plt.plot(domain, d_pow["mean"][0:10], marker='o', label=r'd(pow)')
plt.fill_between(domain, d_pow["min"][0:10], d_pow["max"][0:10], alpha=0.2)

plt.plot(domain, d_cbrt["mean"][0:10], marker='o', label=r'd(cbrt)')
plt.fill_between(domain, d_cbrt["min"][0:10], d_cbrt["max"][0:10], alpha=0.2)

# Other options
plt.legend(fontsize=12)
plt.grid()
plt.savefig("cbrt_plot.png", dpi=300)

