module tb_adder;
    logic   a, b, ci;
    logic   sum, co;

    rtl_adder dut (
        .a(a),  .b(b),  .ci(ci),
        .sum(sum),  .co(co)
    );

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, tb_adder);

        //Test all 8 input combinations
        {a, b, ci} = 3'b000; #10;
        {a, b, ci} = 3'b001; #10;
        {a, b, ci} = 3'b010; #10;
        {a, b, ci} = 3'b011; #10;
        {a, b, ci} = 3'b100; #10;
        {a, b, ci} = 3'b101; #10;
        {a, b, ci} = 3'b110; #10;
        {a, b, ci} = 3'b111; #10;
        
        $display("All test complete.");
        $finish;
    end

    //Print result
    initial begin
        $monitor("a = %b b = %b ci = %b | sum = %b co = %b", a, b, ci, sum, co);
    end
endmodule