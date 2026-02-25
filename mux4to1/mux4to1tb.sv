module mux4to1_tb;
    logic [3:0] in;
    logic [1:0] sel;
    logic y;

    // Instantiate DUT
    mux4to1 dut (
        .in(in),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, mux4to1_tb);

        in = 4'b1010; // in[0]=0, in[1]=1, in[2]=0, in[3]=1

        sel = 2'b00; #10; $display("sel=%b in[0]=%b -> y=%b", sel, in[0], y);
        sel = 2'b01; #10; $display("sel=%b in[1]=%b -> y=%b", sel, in[1], y);
        sel = 2'b10; #10; $display("sel=%b in[2]=%b -> y=%b", sel, in[2], y);
        sel = 2'b11; #10; $display("sel=%b in[3]=%b -> y=%b", sel, in[3], y);

        $finish;
    end
endmodule