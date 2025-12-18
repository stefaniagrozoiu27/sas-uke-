import numpy as np
import matplotlib.pyplot as plt

input_file = "../sim/data/input_points.txt"
output_file = "../sim/data/output_points.txt"
reference_file = "../sim/data/reference_points.txt"

input_data = np.loadtxt(input_file)
input_points = input_data[:, :3]

output_points = np.loadtxt(output_file)

reference_points = np.loadtxt(reference_file)

plt.figure(figsize=(9, 7))

plt.scatter(reference_points[:, 0], reference_points[:, 1],
            marker='x', s=60, label="Reference (Ground Truth)")

plt.scatter(input_points[:, 0], input_points[:, 1],
            s=25, alpha=0.7, label="Input (Distorted)")

plt.scatter(output_points[:, 0], output_points[:, 1],
            s=25, alpha=0.7, label="Output (Corrected - Verilog)")

plt.axis("equal")
plt.grid(True)
plt.legend()

plt.xlabel("X [m]")
plt.ylabel("Y [m]")
plt.title("Rolling Shutter Motion Compensation (Verilog)")

plt.xlim(4.0, 6.0)
plt.ylim(-6.0, 6.0)

plt.tight_layout()

plt.savefig("../sim/data/rolling_shutter_correction.png", dpi=150)
print("Plot saved to sim/data/rolling_shutter_correction.png")
