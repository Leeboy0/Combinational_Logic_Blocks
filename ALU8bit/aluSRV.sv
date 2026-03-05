module aluSRV;
    parameter Width = 8;

    logic [Width-1:0] a, b;
    logic [2:0]       alu_op;
    logic [Width-1:0] result;
    logic             zero, carry_out, overflow, negative;

    // ===== SCOREBOARD FUNCTION =====
    // Returns 1 if pass, 0 if fail
    function automatic logic scoreboard(
        input logic [Width-1:0] in_a, in_b,
        input logic [2:0]       op,
        input logic [Width-1:0] actual_result,
        input logic             actual_zero,
        input logic             actual_carry,
        input logic             actual_overflow,
        input logic             actual_negative
    );
        // Reference model — compute expected values
        logic [Width:0]   exp_full;
        logic [Width-1:0] exp_result;
        logic             exp_zero, exp_carry, exp_overflow, exp_negative;
        logic             pass;

        case (op)
            3'b000: exp_full = {1'b0, in_a} + {1'b0, in_b};
            3'b001: exp_full = {1'b0, in_a} - {1'b0, in_b};
            3'b010: exp_full = {1'b0, in_a  & in_b};
            3'b011: exp_full = {1'b0, in_a  | in_b};
            3'b100: exp_full = {1'b0, in_a  ^ in_b};
            3'b101: exp_full = {1'b0, ~in_a};
            3'b110: exp_full = {1'b0, in_a  << 1};
            3'b111: exp_full = {1'b0, in_a  >> 1};
            default: exp_full = '0;
        endcase

        exp_result   = exp_full[Width-1:0];
        exp_carry    = exp_full[Width];
        exp_zero     = (exp_result == '0);
        exp_negative = exp_result[Width-1];
        exp_overflow = (op == 3'b000) ?
            (~in_a[Width-1] & ~in_b[Width-1] &  exp_result[Width-1]) |
            ( in_a[Width-1] &  in_b[Width-1] & ~exp_result[Width-1])
          : (op == 3'b001) ?
            (~in_a[Width-1] &  in_b[Width-1] &  exp_result[Width-1]) |
            ( in_a[Width-1] & ~in_b[Width-1] & ~exp_result[Width-1])
          : 1'b0;

        // Compare each output
        pass = 1;

        if (actual_result !== exp_result) begin
            $error("RESULT MISMATCH | op=%03b a=%08b b=%08b | got=%08b expected=%08b",
                    op, in_a, in_b, actual_result, exp_result);
            pass = 0;
        end
        if (actual_zero !== exp_zero) begin
            $error("ZERO FLAG MISMATCH | op=%03b a=%08b b=%08b | got=%b expected=%b",
                    op, in_a, in_b, actual_zero, exp_zero);
            pass = 0;
        end
        if (actual_carry !== exp_carry) begin
            $error("CARRY MISMATCH | op=%03b a=%08b b=%08b | got=%b expected=%b",
                    op, in_a, in_b, actual_carry, exp_carry);
            pass = 0;
        end
        if (actual_overflow !== exp_overflow) begin
            $error("OVERFLOW MISMATCH | op=%03b a=%08b b=%08b | got=%b expected=%b",
                    op, in_a, in_b, actual_overflow, exp_overflow);
            pass = 0;
        end
        if (actual_negative !== exp_negative) begin
            $error("NEGATIVE MISMATCH | op=%03b a=%08b b=%08b | got=%b expected=%b",
                    op, in_a, in_b, actual_negative, exp_negative);
            pass = 0;
        end

        return pass;
    endfunction
    // ===== END SCOREBOARD =====

    alu #(.WIDTH(Width)) dut (
        .a(a), .b(b), .alu_op(alu_op),
        .result(result), .zero(zero),
        .carry_out(carry_out), .overflow(overflow),
        .negative(negative)
    );

    // Counters to track pass/fail
    int pass_count = 0;
    int fail_count = 0;

    // Weighted random operand function
    function automatic logic [7:0] rand_operand();
        logic [6:0] roll;
        roll = $urandom_range(0, 99);
        if      (roll < 15) return 8'h00;
        else if (roll < 30) return 8'hFF;
        else if (roll < 40) return 8'h7F;
        else if (roll < 50) return 8'h80;
        else                return $urandom_range(1, 254);
    endfunction

    initial begin
        $dumpfile("aluSRV.vcd");
        $dumpvars(0, aluSRV);

        $display("=== CRV Stage 2: Random Stimulus + Scoreboard ===");

        repeat(200) begin
            a      = rand_operand();
            b      = rand_operand();
            alu_op = $urandom_range(0, 7);
            #10;

            // Call scoreboard — it checks everything automatically
            if (scoreboard(a, b, alu_op,
                           result, zero, carry_out, overflow, negative))
                pass_count++;
            else
                fail_count++;
        end

        // Final summary
        $display("=== Scoreboard Summary ===");
        $display("PASS: %0d / 200", pass_count);
        $display("FAIL: %0d / 200", fail_count);

        if (fail_count == 0)
            $display("ALL TESTS PASSED ✓");
        else
            $display("FAILURES DETECTED — check $error messages above");

        $finish;
    end

endmodule