module imu_integrator #(
  parameter WP = 32 // Q16.16
)(
  input  signed [WP-1:0] a,     // accelerație (m/s^2)
  input  signed [WP-1:0] dt,    // timp (s)
  input  signed [WP-1:0] v_in,  // v(k)

  output signed [WP-1:0] v_out, // v(k+1)
  output signed [WP-1:0] dp     // deplasare în dt
);

  // v_out = v + a * dt
  wire signed [2*WP-1:0] av = a * dt;
  assign v_out = v_in + (av >>> 16);

  // dp = v * dt
  wire signed [2*WP-1:0] vp = v_in * dt;
  assign dp = vp >>> 16;

endmodule
