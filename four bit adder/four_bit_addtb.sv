module bitAdd_4_tb;
    logic [3:0] a, b;
    logic ci;
    logic [3:0] out;
    logic co;

    bitAdd_4 dut (
        .a(a),
        .b(b),
        .ci(ci),
        .out(out),
        .co(co)
    );

    initial begin
        $dumpfile("bitAdd_4.vcd");
        $dumpvars(0, bitAdd_4_tb);
        $monitor("a = %b b = %b ci = %b out = %b co = %b", a, b, ci, out, co);

        //Test 01: 0 + 0 + 0
        a = 4'b0000; b = 4'b0000; ci = 0; #10;

        //Test 02: 1 + 1 + 0
        a = 4'b0001; b = 4'b0001; ci = 0; #10;

        //Test 03: 1 + 1 + 1 Carry in
        a = 4'b0001; b = 4'b0001; ci = 1; #10;

        //Test 04: Overflow 
        a = 4'b1111; b = 4'b1111; ci = 1; #10;

        //Test 05: Carry out 
        a = 4'b1000; b = 4'b1000; ci = 0; #10;

        $finish;
    end

    endmodule