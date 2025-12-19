#!/bin/bash
set -e

iverilog -g2012 -o sim_rs \
  tb/tb_motion_corrector.sv \
  ../rtl/top_motion_corrector.v \
  ../rtl/point_processing/lerp.v \
  ../rtl/imu/imu_integrator.v \
  ../rtl/point_processing/quat_nlerp.v \
  ../rtl/point_processing/quat_conj.v \
  ../rtl/point_processing/quat_rotate_vec.v

vvp sim_rs
