module top_motion_corrector #(
  parameter WP = 32
)(
  input  signed [WP-1:0] px, py, pz, // punct distorsionat
  input  signed [WP-1:0] dt,          // rolling shutter time

  // IMU
  input  signed [WP-1:0] a_x,          // accelerație IMU pe X
  input  signed [WP-1:0] v_prev,       // v(k)

  output signed [WP-1:0] v_next,       // v(k+1)
  output signed [WP-1:0] cx, cy, cz     // punct corectat
);

  wire signed [WP-1:0] dx;

  imu_integrator #(.WP(WP)) imu (
    .a(a_x),
    .dt(dt),
    .v_in(v_prev),
    .v_out(v_next),
    .dp(dx)
  );

  // rolling shutter correction
  assign cx = px + dx;
  assign cy = py;
  assign cz = pz;

endmodule
