module quat_nlerp #(
  parameter W=32 // Q1.30 signed
)(
  input  logic             clk, rst,
  input  logic             in_valid,
  input  logic signed [W-1:0] q0_w,q0_x,q0_y,q0_z,
  input  logic signed [W-1:0] q1_w,q1_x,q1_y,q1_z,
  input  logic signed [31:0]  alpha, // Q0.30
  output logic             out_valid,
  output logic signed [W-1:0] q_w,q_x,q_y,q_z
);
  // q = (1-a)*q0 + a*q1
  // apoi normalizezi: q /= sqrt(w^2+x^2+y^2+z^2)
  // Pentru proiect: poți folosi o aproximare inv_sqrt LUT/CORDIC sau 1 iter NR.
endmodule
