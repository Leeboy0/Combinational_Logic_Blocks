module alutb;
    parameter Width = 8;

    // Internal signals — no input/output in a testbench
    logic [Width-1:0] a, b;
    logic [2:0]       alu_op;
    logic [Width-1:0] result;
    logic            zero, carry_out, overflow, negative;

    alu #(.Width(Width)) dut( 
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero),
        .carry_out(carry_out),
        .overflow(overflow),
        .negative(negative)
    );

    // Task to apply inputs and display results
    task apply_and_check(
        input logic [Width-1:0] in_a, in_b,
        input logic [2:0]       op,
        input string            op_name
    );

     a = in_a; b = in_b; alu_op = op;
        #10;
        $display("[%s] a=%0d b=%0d | result=%0d | zero=%b carry=%b overflow=%b negative=%b",
                 op_name, in_a, in_b, result, zero, carry_out, overflow, negative);
    endtask


    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alutb);

        $display("=== ALU Testbench ===");

        // --- ADD ---
        apply_and_check(8'd10,  8'd20,  3'b000, "ADD");        // normal
        apply_and_check(8'hFF,  8'h01,  3'b000, "ADD carry");  // carry_out expected
        apply_and_check(8'd127, 8'd1,   3'b000, "ADD ovflow"); // signed overflow

        // --- SUB ---
        apply_and_check(8'd20,  8'd10,  3'b001, "SUB");        // normal
        apply_and_check(8'd10,  8'd20,  3'b001, "SUB neg");    // negative result
        apply_and_check(8'd0,   8'd1,   3'b001, "SUB undrfl"); // underflow

        // --- Zero flag ---
        apply_and_check(8'd42,  8'd42,  3'b001, "SUB zero");   // result = 0, zero=1
        apply_and_check(8'd0,   8'd0,   3'b000, "ADD zero");

        // --- Bitwise ---
        apply_and_check(8'hF0,  8'h0F,  3'b010, "AND");        // expect 0x00
        apply_and_check(8'hF0,  8'h0F,  3'b011, "OR");         // expect 0xFF
        apply_and_check(8'hFF,  8'hFF,  3'b100, "XOR");        // expect 0x00
        apply_and_check(8'hAA,  8'h00,  3'b101, "NOT");        // expect 0x55

        // --- Shifts ---
        apply_and_check(8'b00000001, 8'h00, 3'b110, "SLL");    // expect 0x02
        apply_and_check(8'b10000000, 8'h00, 3'b110, "SLL MSB");// MSB shifts out
        apply_and_check(8'b10000000, 8'h00, 3'b111, "SRL");    // expect 0x40
        apply_and_check(8'b00000001, 8'h00, 3'b111, "SRL LSB");// LSB shifts out

        $display("=== Done ===");
        $finish;
    end

endmodule