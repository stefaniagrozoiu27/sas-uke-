module quat_nlerp (
  input  signed [31:0] q0_w, q0_x, q0_y, q0_z,
  input  signed [31:0] q1_w, q1_x, q1_y, q1_z,
  input        [31:0]  alpha,
  output signed [31:0] qo_w, qo_x, qo_y, qo_z
);
  wire [31:0] one_minus = 32'h4000_0000 - alpha;

  function automatic signed [31:0] blend;
    input signed [31:0] a0, a1;
    input [31:0] am, al;
    reg   signed [63:0] m0, m1;
    begin
      m0 = a0 * $signed(am);
      m1 = a1 * $signed(al);
      blend = (m0 + m1) >>> 30;
    end
  endfunction

  assign qo_w = blend(q0_w, q1_w, one_minus, alpha);
  assign qo_x = blend(q0_x, q1_x, one_minus, alpha);
  assign qo_y = blend(q0_y, q1_y, one_minus, alpha);
  assign qo_z = blend(q0_z, q1_z, one_minus, alpha);

endmodule