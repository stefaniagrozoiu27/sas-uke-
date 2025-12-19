module quat_conj(
  input  signed [31:0] qi_w, qi_x, qi_y, qi_z,
  output signed [31:0] qo_w, qo_x, qo_y, qo_z
);
  assign qo_w = qi_w;
  assign qo_x = -qi_x;
  assign qo_y = -qi_y;
  assign qo_z = -qi_z;
endmodule