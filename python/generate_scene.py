import numpy as np
import math
import matplotlib.pyplot as plt

N = 50
scan_time = 0.2                 
v = np.array([3.0, 0.0, 0.0])   
omega = math.radians(60)       


dt = np.linspace(0, scan_time, N)


y = np.linspace(-5, 5, N)

reference_points = np.stack([
    np.ones(N) * 5.0,   
    y,
    np.zeros(N)
], axis=1)


def rot_z(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([
        [ c, -s, 0],
        [ s,  c, 0],
        [ 0,  0, 1]
    ])

distorted_points = []

for i in range(N):
    t = dt[i]

    trans = v * t
    theta = omega * t
    R = rot_z(theta)

    p_world = reference_points[i]
    p_sensor = R @ (p_world - trans)

    distorted_points.append(p_sensor)

distorted_points = np.array(distorted_points)

np.savetxt("../sim/data/input_points.txt",
           np.column_stack([reference_points, dt]),
           fmt="%.6f")

np.savetxt("../sim/data/input_points.txt",
           np.column_stack([distorted_points, dt]),
           fmt="%.6f")


plt.figure(figsize=(8,6))

plt.scatter(reference_points[:,0], reference_points[:,1],
            label="Reference (t=0)", marker="x", s=30)

plt.scatter(distorted_points[:,0], distorted_points[:,1],
            label="Distorted (rolling shutter)", s=12)

plt.axis("equal")
plt.xlim(4.5, 5.5)
plt.ylim(-2.0, 2.0)

plt.legend()
plt.title("Strong Motion Distortion (Zoomed)")
plt.xlabel("X [m]")
plt.ylabel("Y [m]")

plt.savefig("../sim/data/generated_scene.png", dpi=150)
print("Plot saved to sim/data/generated_scene.png")
