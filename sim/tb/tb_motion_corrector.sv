`timescale 1ns/1ps

module tb_motion_corrector;

  localparam int WP = 32;
  localparam real SCALE = 65536.0; // Q16.16

  // fisiere
  integer fin, fout;
  integer count;

  // date citite
  real rx, ry, rz, rdt;

  // semnale DUT
  reg  signed [WP-1:0] px, py, pz;
  reg  signed [WP-1:0] dt;
  reg  signed [WP-1:0] a_x;
  reg  signed [WP-1:0] v_prev;

  wire signed [WP-1:0] v_next;
  wire signed [WP-1:0] cx, cy, cz;

  // DUT
  top_motion_corrector #(.WP(WP)) dut (
    .px(px), .py(py), .pz(pz),
    .dt(dt),
    .a_x(a_x),
    .v_prev(v_prev),
    .v_next(v_next),
    .cx(cx), .cy(cy), .cz(cz)
  );

  function signed [WP-1:0] to_q16_16(input real r);
    to_q16_16 = $rtoi(r * SCALE);
  endfunction

  function real from_q16_16(input signed [WP-1:0] q);
    from_q16_16 = q / SCALE;
  endfunction

  initial begin
    count  = 0;
    v_prev = 0;

    // accelerație constantă (exemplu)
    a_x = to_q16_16(1.5);

    fin = $fopen("data/input_points.txt", "r");
    if (fin == 0) begin
      $display("ERROR: cannot open input_points.txt");
      $finish;
    end

    fout = $fopen("data/imu_corrected_points.txt", "w");
    $fwrite(fout, "# cx cy cz\n");

    while ($fscanf(fin, "%f %f %f %f", rx, ry, rz, rdt) == 4) begin
      count = count + 1;

      px = to_q16_16(rx);
      py = to_q16_16(ry);
      pz = to_q16_16(rz);
      dt = to_q16_16(rdt);

      #1; // timp simbolic de propagare

      $fwrite(
        fout,
        "%0.6f %0.6f %0.6f\n",
        from_q16_16(cx),
        from_q16_16(cy),
        from_q16_16(cz)
      );

      v_prev = v_next;
    end

    $display("Processed %0d points", count);

    $fclose(fin);
    $fclose(fout);
    $display("Wrote data/output_points.txt");

    $finish;
  end

endmodule
