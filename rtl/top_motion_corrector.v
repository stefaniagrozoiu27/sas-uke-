module top_motion_corrector #(
  parameter WP = 32   // Q16.16
)(
  input  signed [WP-1:0] px, py, pz,   // punct distorsionat
  input  [31:0]          alpha,        // dt / T  (Q0.30)

  input  signed [WP-1:0] vT_x, vT_y, vT_z, // v * T (Q16.16)

  output signed [WP-1:0] cx, cy, cz    // punct corectat
);

  // interpolare: t(t) = lerp(0, vT, alpha)
  wire signed [WP-1:0] tx, ty, tz;

  lerp #(.W(WP)) lerp_x (.a(0), .b(vT_x), .alpha(alpha), .out(tx));
  lerp #(.W(WP)) lerp_y (.a(0), .b(vT_y), .alpha(alpha), .out(ty));
  lerp #(.W(WP)) lerp_z (.a(0), .b(vT_z), .alpha(alpha), .out(tz));

  // corecție punct
  assign cx = px + tx;
  assign cy = py + ty;
  assign cz = pz + tz;

endmodule
