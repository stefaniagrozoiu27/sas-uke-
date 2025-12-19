module top_motion_corrector #(
  parameter WP = 32   // Q16.16
)(
  input  signed [WP-1:0] px, py, pz, // punct distorsionat
  input  signed [WP-1:0] dt,          // rolling shutter time (sec, Q16.16)

  // IMU (translație)
  input  signed [WP-1:0] a_x,
  input  signed [WP-1:0] v_prev,

  output signed [WP-1:0] v_next,
  output signed [WP-1:0] cx, cy, cz
);

  wire signed [WP-1:0] dx;

  imu_integrator #(.WP(WP)) imu (
    .a(a_x),
    .dt(dt),
    .v_in(v_prev),
    .v_out(v_next),
    .dp(dx)
  );

  localparam signed [WP-1:0] YAW_TOTAL = 32'sd11469;

  localparam signed [WP-1:0] SCAN_TIME_Q = 32'sd13107;

  wire signed [2*WP-1:0] alpha_ext = (dt <<< 16) / SCAN_TIME_Q;
  wire signed [WP-1:0]   alpha     = alpha_ext[WP-1:0];

  wire signed [WP-1:0] yaw_t = (alpha * YAW_TOTAL) >>> 16;
  wire signed [WP-1:0] half_yaw = yaw_t >>> 1;

  wire signed [31:0] qw = 32'h0001_0000;
  wire signed [31:0] qx = 0;
  wire signed [31:0] qy = 0;
  wire signed [31:0] qz = half_yaw;

  wire signed [WP-1:0] rx, ry, rz;

  quat_rotate_vec #(.WP(WP)) rot (
    .q_w(qw), .q_x(qx), .q_y(qy), .q_z(qz),
    .vx(px), .vy(py), .vz(pz),
    .ox(rx), .oy(ry), .oz(rz)
  );

  assign cx = rx + dx;
  assign cy = ry;
  assign cz = rz;

endmodule
