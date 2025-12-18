module top_motion_corrector #(
  parameter WP = 32
)(
  input  signed [WP-1:0] px, py, pz,

  input  signed [WP-1:0] dt,

  input  signed [WP-1:0] v_x, v_y, v_z,

  input  [31:0] invT_q0_30,

  output signed [WP-1:0] cx, cy, cz
);

  wire signed [WP+31:0] alpha_mult = dt * $signed(invT_q0_30);
  wire signed [31:0]    alpha_raw  = alpha_mult >>> 16; // Q0.30

  wire [31:0] alpha_clamped =
      (alpha_raw <= 0) ? 32'd0 :
      (alpha_raw >= 32'sh4000_0000) ? 32'h4000_0000 : // 1.0 in Q0.30
      alpha_raw[31:0];

  wire signed [WP+WP-1:0] mtx = v_x * dt;
  wire signed [WP+WP-1:0] mty = v_y * dt;
  wire signed [WP+WP-1:0] mtz = v_z * dt;

  wire signed [WP-1:0] tx = mtx >>> 16;
  wire signed [WP-1:0] ty = mty >>> 16;
  wire signed [WP-1:0] tz = mtz >>> 16;

  assign cx = px + tx;
  assign cy = py + ty;
  assign cz = pz + tz;

endmodule