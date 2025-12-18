module tb_motion_corrector;

  localparam int  WP    = 32;
  localparam real SCALE = 65536.0; // Q16.16

  // aceiași parametri ca în Python
  localparam real SCAN_TIME = 0.2;
  localparam real VX = 3.0;
  localparam real VY = 0.0;
  localparam real VZ = 0.0;

  reg  signed [WP-1:0] px, py, pz;
  reg  [31:0]          alpha;

  reg  signed [WP-1:0] vT_x, vT_y, vT_z;

  wire signed [WP-1:0] cx, cy, cz;

  top_motion_corrector #(.WP(WP)) dut (
    .px(px), .py(py), .pz(pz),
    .alpha(alpha),
    .vT_x(vT_x), .vT_y(vT_y), .vT_z(vT_z),
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

  function [31:0] to_q0_30(input real r);
    begin to_q0_30 = $rtoi(r * (2.0**30)); end
  endfunction

  initial begin
    // vT = v * T
    vT_x = to_q16_16(VX * SCAN_TIME);
    vT_y = to_q16_16(VY * SCAN_TIME);
    vT_z = to_q16_16(VZ * SCAN_TIME);

    fin  = $fopen("data/input_points.txt", "r");
    if (fin == 0) begin
      $display("ERROR: cannot open input_points.txt");
      $finish;
    end

    fout = $fopen("data/output_points.txt", "w");
    $fwrite(fout, "# cx cy cz\n");

    // citește punct cu punct
    while ($fscanf(fin, "%f %f %f %f", rx, ry, rz, rdt) == 4) begin
      px    = to_q16_16(rx);
      py    = to_q16_16(ry);
      pz    = to_q16_16(rz);
      alpha = to_q0_30(rdt / SCAN_TIME);

      #1; // evaluare combinatorie

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
