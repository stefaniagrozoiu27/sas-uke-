module quat_to_rotmat #(
  parameter W=32 // Q1.30
)(
  input  logic clk, rst,
  input  logic in_valid,
  input  logic signed [W-1:0] qw,qx,qy,qz,
  output logic out_valid,
  output logic signed [31:0] r00,r01,r02,
  output logic signed [31:0] r10,r11,r12,
  output logic signed [31:0] r20,r21,r22
);

endmodule
