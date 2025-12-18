module lerp #(
  parameter W = 32
)(
  input  signed [W-1:0] a,
  input  signed [W-1:0] b,
  input  [31:0]         alpha,
  output signed [W-1:0] out
);
  wire signed [W-1:0]  diff = b - a;
  wire signed [W+31:0] mult = diff * $signed(alpha);
  assign out = a + (mult >>> 30);
endmodule
