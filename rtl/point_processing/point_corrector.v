module point_corrector #(
  parameter WP=32 // Q16.16
)(
  input  logic clk, rst,
  input  logic in_valid,
  input  logic signed [WP-1:0] px,py,pz,
  input  logic signed [WP-1:0] tx,ty,tz, // translație la dt
  input  logic signed [31:0] r00,r01,r02,r10,r11,r12,r20,r21,r22, // Q1.30
  output logic out_valid,
  output logic signed [WP-1:0] cx,cy,cz
);

endmodule
