import numpy as np
import matplotlib.pyplot as plt

reference_file = "../sim/data/reference_points.txt"
input_file     = "../sim/data/input_points.txt"
quat_file      = "../sim/data/output_points.txt"

reference = np.loadtxt(reference_file)
input_data = np.loadtxt(input_file)
input_pts = input_data[:, :3]
quat = np.loadtxt(quat_file, comments="#")

ref_center  = np.mean(reference[:, :2], axis=0)
quat_center = np.mean(quat[:, :2], axis=0)

offset = ref_center - quat_center

quat_aligned = quat.copy()
quat_aligned[:, 0] += offset[0]
quat_aligned[:, 1] += offset[1]

print(f"Applied offset: dx={offset[0]:.4f}, dy={offset[1]:.4f}")

plt.figure(figsize=(9, 7))

plt.scatter(reference[:, 0], reference[:, 1],
            marker='x', s=70, label="Reference (Ground Truth)")

plt.scatter(input_pts[:, 0], input_pts[:, 1],
            s=25, alpha=0.5, label="Input (Distorted)")

plt.scatter(quat_aligned[:, 0], quat_aligned[:, 1],
            s=30, alpha=0.9, label="RS + IMU + Quaternion (Aligned)")

plt.axis("equal")
plt.grid(True)
plt.legend()

plt.xlabel("X [m]")
plt.ylabel("Y [m]")
plt.title("Quaternion-based Rotation Compensation (Aligned)")

plt.xlim(4.0, 6.0)
plt.ylim(-6.0, 6.0)

plt.tight_layout()
plt.savefig("../sim/data/quaternion_compensation.png", dpi=150)

print("Plot saved to sim/data/quaternion_compensation.png")