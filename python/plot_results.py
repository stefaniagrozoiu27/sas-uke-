import numpy as np
import matplotlib.pyplot as plt

# -----------------------------
# CĂI CĂTRE FIȘIERE
# -----------------------------
input_file = "../sim/data/input_points.txt"
output_file = "../sim/data/output_points.txt"
reference_file = "../sim/data/reference_points.txt"

# -----------------------------
# ÎNCĂRCARE DATE
# -----------------------------
# input: x y z dt
input_data = np.loadtxt(input_file)
input_points = input_data[:, :3]

# output: cx cy cz
output_points = np.loadtxt(output_file)

# reference: x y z
reference_points = np.loadtxt(reference_file)

# -----------------------------
# PLOT
# -----------------------------
plt.figure(figsize=(9, 7))

plt.scatter(reference_points[:, 0], reference_points[:, 1],
            marker='x', s=40, label="Reference (Ground Truth)")

plt.scatter(input_points[:, 0], input_points[:, 1],
            s=20, alpha=0.7, label="Input (Distorted)")

plt.scatter(output_points[:, 0], output_points[:, 1],
            s=20, alpha=0.7, label="Output (Corrected - Verilog)")

plt.axis("equal")
plt.grid(True)
plt.legend()

plt.xlabel("X [m]")
plt.ylabel("Y [m]")
plt.title("Motion Compensation using Linear Interpolation (Verilog)")

# zoom ca să se vadă diferența clar
plt.xlim(4.0, 6.0)
plt.ylim(-6.0, 6.0)

plt.tight_layout()
plt.savefig("../sim/data/comparison_plot.png", dpi=150)
print("Plot saved to sim/data/comparison_plot.png")

