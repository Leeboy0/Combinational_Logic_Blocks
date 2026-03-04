module aluSRV;
    parameter Width = 8;

    logic[Width - 1:0] a, b;
    logic[2:0]      alu_op;
    logic[Width - 1:0] result;
    logic           zero, carry_out,overflow,negative;

    class alu_transcation;
        rand logic[Width - 1:0] a,b;
        rand logic [2:0]    alu_op;

        // Constraint 1: bias a and b toward edge cases
        constraint edge_bias{
            a dist {
                8'h00 := 15, // 15% chance of zero
                8'hFF := 15, // 15% chance of max
                8'h7F := 10, // 10% chance of +127 (signed max)
                8'h80 := 10, // 10% chance of -128 (signed min)
                [8'h01:8'hFE] := 50 // 50% fully random
            };
            b dist {
                8'h00 := 15,
                8'hFF := 15,
                8'h7F := 10,
                8'h80 := 10,
                [8'h01:8'hFE] := 50
            };
        }

            // Constraint 2: all opcodes equally likely
            constraint op_dist {
                alu_op dist{
                    3'b000 := 1,
                    3'b001 := 1,
                    3'b010 := 1,
                    3'b011 := 1,
                    3'b100 := 1,
                    3'b101 := 1,
                    3'b110 := 1,
                    3'b111 := 1
                };
           }
        
        
    endclass //className

    alu#(.Width(Width)) dut(
         .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero),
        .carry_out(carry_out),
        .overflow(overflow),
        .negative(negative)
    );

	alu_transcation txn;	

    initial begin
        $dumpfile("aluSRV.vcd");
        $dumpvars(0, aluSRV);

        

        $display("=== CRV Stage 1: Random Stimulus ===");
	txn = new();
        repeat(200) begin
            assert (txn.randomize()) 
            else   $fatal("Ramdomization failed!");

            //Driver inputs
            a = txn.a;
            b = txn.b;
            alu_op = txn.alu_op;
            #10;

            $display("op=%03b a=%08b b=%08b | result=%08b zero=%b carry=%b overflow=%b negative=%b",
                      alu_op, a, b, result, zero, carry_out, overflow, negative);
        end

        $display("=== Done ===");
        $finish;
    end

endmodule