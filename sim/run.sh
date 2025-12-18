#!/bin/bash
set -e

iverilog -g2012 -o sim_rs \
  tb/tb_motion_corrector.sv \
  ../rtl/top_motion_corrector.v \
  ../rtl/point_processing/lerp.v

vvp sim_rs
