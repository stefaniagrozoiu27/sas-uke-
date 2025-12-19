# Motion Distortion Correction Using Verilog and IMU Data

## Overview

This project implements a simple but complete motion distortion correction pipeline for scanned 3D points.
The main goal is to correct the motion effects caused by camera movemet, all implemented in Verilog.
We also used Python for:
- generating synthetic test data
- visualizing the results
All motion compensation logic itself is implemented in hardware-style Verilog modules and tested using a Verilog testbench.

## What the Project Demonstrates
The project incrementally builds a motion correction pipeline that includes:
- linear interpolation for motion compensation
- rolling shutter correction
- IMU-based pose estimation (acceleration → velocity → displacement)
- point-by-point processing (hardware-friendly)
- quaternion-based rotation interpolation (for rotational motion)
Each feature is evaluated separately using plots, so their individual effects can be clearly observed.

## Project Structure
sas-uke-/
    python/
        generate_scene.py
        plot_imu_results.py
        plot_quanterin_effect.py
        plot_results.py
    rtl/
        imu/
            imu_integrator.v
        point_processing/
            lerp.v
            point_corrector.v
            quat_conj.v
            quat_nlerp.v
            quat_rotate_vec.v
            quat_to_rotmat.v
        top_motion_corrector.v
    sim/
        data/
            comparison_plot.png
            generated_scene.png
            imu_corrected_points.txt
            imu_motion_compensation.png
            input_points.txt
            output_points.txt
            quaternion_compensation.png
            reference_points.txt
            rolling_shutter_correction.png
        tb/
            tb_motion_corrector.sv
        a.out
        run.sh
        sim
        sim_lin
        sim_rs
        sim.out
    README.md

## Implemented Features

### 1. Linear Interpolation for Motion Compensation
Motion compensation is based on linear interpolation of displacement over time.
Each point is corrected proportionally to its acquisition time (`dt`).
This assumes smooth motion and keeps the design simple enough for hardware implementation using fixed-point arithmetic (Q16.16).

### 2. Rolling Shutter Correction
Rolling shutter distortion occurs because points are captured at different times while the sensor is moving.

How it works:
- Each input point includes a timestamp (`dt`)
- A displacement proportional to motion during `dt` is applied
- Points are corrected independently

This stage assumes constant velocity, which is enough to remove most of the visible curvature caused by rolling shutter.

### 3. IMU Integration for Pose Estimation
To go beyond the constant velocity assumption, IMU data is integrated.

IMU pipeline:
1. Acceleration → velocity
2. Velocity → displacement

This is implemented in `imu_integrator.v` using fixed-point arithmetic.
The IMU correction is applied incrementally on top of rolling shutter correction, improving alignment with the ground truth.

### 4. Point-by-Point / Scan-Line Processing

The entire pipeline processes data point-by-point.

This makes the design:
- suitable for streaming sensors
- easy to map to hardware
- compatible with scan-line or LiDAR-style acquisition
No global buffers or full-frame assumptions are used.

### 5. Quaternion-Based Rotation Interpolation
For rotational motion (yaw), orientation is represented using quaternions instead of Euler angles.
Quaternion interpolation avoids singularities and produces smooth rotation, which is especially important for rolling shutter correction where each point has a different acquisition time.

## How to Run the Project

### 1. Generate Test Data
From the `python/` directory:
python3 generate_scene.py

This generates:
- `input_points.txt` (distorted scan)
- `reference_points.txt` (ground truth)

### 2. Run the Verilog Simulation
From the `sim/` directory:
chmod +x run.sh
./run.sh

This:
- compiles the Verilog modules
- runs the testbench
- generates corrected output files

### 3. Visualize the Results
#### Rolling Shutter Correction
python3 plot_results.py

Generates:
rolling_shutter_correction.png

#### IMU-Based Motion Compensation
python3 plot_imu_results.py

Generates:
imu_motion_compensation.png

## Conclusion
This project shows how rolling shutter distortion can be corrected using simple motion models and then improved using IMU-based motion estimation.
By keeping the design point-based and hardware-friendly, the implementation closely matches how such a system would be built in practice.

The separate visualizations make it easy to understand the contribution of each correction stage.
 