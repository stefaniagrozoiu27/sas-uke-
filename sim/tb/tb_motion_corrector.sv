module tb_motion_corrector;

  localparam int  WP    = 32;
  localparam real SCALE = 65536.0;

  localparam real SCAN_TIME = 0.2;
  localparam real VX = 3.0;
  localparam real VY = 0.0;
  localparam real VZ = 0.0;

  reg  signed [WP-1:0] px, py, pz;
  reg  signed [WP-1:0] dt_q;

  reg  signed [WP-1:0] v_x, v_y, v_z;
  reg  [31:0]          invT_q0_30;

  wire signed [WP-1:0] cx, cy, cz;

  top_motion_corrector #(.WP(WP)) dut (
    .px(px), .py(py), .pz(pz),
    .dt(dt_q),
    .v_x(v_x), .v_y(v_y), .v_z(v_z),
    .invT_q0_30(invT_q0_30),
    .cx(cx), .cy(cy), .cz(cz)
  );

  integer fin, fout;
  real rx, ry, rz, rdt;

  function signed [WP-1:0] to_q16_16(input real r);
    begin to_q16_16 = $rtoi(r * SCALE); end
  endfunction

  function real from_q16_16(input signed [WP-1:0] q);
    begin from_q16_16 = q / SCALE; end
  endfunction

  initial begin
    v_x = to_q16_16(VX);
    v_y = to_q16_16(VY);
    v_z = to_q16_16(VZ);

    invT_q0_30 = $rtoi((1<<30) / SCAN_TIME);

    fin  = $fopen("data/input_points.txt", "r");
    if (fin == 0) begin
      $display("ERROR: cannot open sim/data/input_points.txt");
      $finish;
    end

    fout = $fopen("data/output_points.txt", "w");
    $fwrite(fout, "# cx cy cz\n");

    while ($fscanf(fin, "%f %f %f %f", rx, ry, rz, rdt) == 4) begin
      px   = to_q16_16(rx);
      py   = to_q16_16(ry);
      pz   = to_q16_16(rz);
      dt_q = to_q16_16(rdt);

      #1;

      $fwrite(fout, "%0.6f %0.6f %0.6f\n",
              from_q16_16(cx),
              from_q16_16(cy),
              from_q16_16(cz));
    end

    $fclose(fin);
    $fclose(fout);
    $display("Wrote data/output_points.txt");
    $finish;
  end

endmodule