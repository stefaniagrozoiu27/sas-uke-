module quat_rotate_vec #(
  parameter WP = 32
)(
  input  signed [31:0] q_w, q_x, q_y, q_z,
  input  signed [WP-1:0] vx, vy, vz,
  output signed [WP-1:0] ox, oy, oz
);

  wire signed [31:0] qc_w = q_w;
  wire signed [31:0] qc_x = -q_x;
  wire signed [31:0] qc_y = -q_y;
  wire signed [31:0] qc_z = -q_z;

  wire signed [45:0] v30x = $signed(vx) <<< 14;
  wire signed [45:0] v30y = $signed(vy) <<< 14;
  wire signed [45:0] v30z = $signed(vz) <<< 14;

  wire signed [63:0] c1x = $signed(qc_y)*$signed(v30z) - $signed(qc_z)*$signed(v30y);
  wire signed [63:0] c1y = $signed(qc_z)*$signed(v30x) - $signed(qc_x)*$signed(v30z);
  wire signed [63:0] c1z = $signed(qc_x)*$signed(v30y) - $signed(qc_y)*$signed(v30x);

  wire signed [63:0] tx = c1x <<< 1;
  wire signed [63:0] ty = c1y <<< 1;
  wire signed [63:0] tz = c1z <<< 1;

  wire signed [95:0] qwtx = $signed(qc_w) * $signed(tx);
  wire signed [95:0] qwty = $signed(qc_w) * $signed(ty);
  wire signed [95:0] qwtz = $signed(qc_w) * $signed(tz);

  wire signed [63:0] qw_t_x = qwtx >>> 30;
  wire signed [63:0] qw_t_y = qwty >>> 30;
  wire signed [63:0] qw_t_z = qwtz >>> 30;

  wire signed [95:0] c2x_w = $signed(qc_y)*$signed(tz) - $signed(qc_z)*$signed(ty);
  wire signed [95:0] c2y_w = $signed(qc_z)*$signed(tx) - $signed(qc_x)*$signed(tz);
  wire signed [95:0] c2z_w = $signed(qc_x)*$signed(ty) - $signed(qc_y)*$signed(tx);

  wire signed [63:0] c2x = c2x_w >>> 30;
  wire signed [63:0] c2y = c2y_w >>> 30;
  wire signed [63:0] c2z = c2z_w >>> 30;

  wire signed [63:0] v60x = $signed(v30x) <<< 30;
  wire signed [63:0] v60y = $signed(v30y) <<< 30;
  wire signed [63:0] v60z = $signed(v30z) <<< 30;

  wire signed [63:0] o60x = v60x + qw_t_x + c2x;
  wire signed [63:0] o60y = v60y + qw_t_y + c2y;
  wire signed [63:0] o60z = v60z + qw_t_z + c2z;

  assign ox = o60x >>> 44;
  assign oy = o60y >>> 44;
  assign oz = o60z >>> 44;

endmodule