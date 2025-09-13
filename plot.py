import matplotlib.pyplot as plt
import csv

sizes = []
search_in = []
search_out = []
union = []

with open("result.csv") as f:
    reader = csv.reader(f)
    for row in reader:
        if not row or row[0].startswith("#"):
            continue
        sizes.append(int(row[0]))
        search_in.append(float(row[1]))
        search_out.append(float(row[2]))
        union.append(float(row[3]))


plt.figure(figsize=(8,6))
plt.plot(sizes, union, marker="^", color="blue", label="union")
plt.xlabel("size of set")
plt.ylabel("average time (ns)")
plt.title("union")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig("union.png", dpi=200)

plt.figure(figsize=(8,6))
plt.plot(sizes, search_in, marker="o", color="green", label="search in")
plt.plot(sizes, search_out, marker="s", color="red", label="search out")
plt.xlabel("size of set")
plt.ylabel("average time (ns)")
plt.title("search")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig("search.png", dpi=200)
