import numpy as np
import matplotlib.pyplot as plt

# fisiere
input_file     = "../sim/data/input_points.txt"
imu_file       = "../sim/data/imu_corrected_points.txt"
reference_file = "../sim/data/reference_points.txt"

# citire date
input_data = np.loadtxt(input_file)
input_points = input_data[:, :3]

imu_points = np.loadtxt(imu_file, comments="#")
reference_points = np.loadtxt(reference_file)

# plot
plt.figure(figsize=(9, 7))

plt.scatter(reference_points[:, 0], reference_points[:, 1],
            marker='x', s=60, label="Reference (Ground Truth)")

plt.scatter(input_points[:, 0], input_points[:, 1],
            s=25, alpha=0.6, label="Input (Distorted)")

plt.scatter(imu_points[:, 0], imu_points[:, 1],
            s=25, alpha=0.8, label="IMU Corrected (Verilog)")

plt.axis("equal")
plt.grid(True)
plt.legend()

plt.xlabel("X [m]")
plt.ylabel("Y [m]")
plt.title("IMU-based Motion Compensation (Verilog)")

plt.xlim(4.0, 6.0)
plt.ylim(-6.0, 6.0)

plt.tight_layout()

plt.savefig("../sim/data/imu_motion_compensation.png", dpi=150)
print("Plot saved to sim/data/imu_motion_compensation.png")
