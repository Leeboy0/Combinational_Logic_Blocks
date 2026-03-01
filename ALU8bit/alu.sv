module alu #(parameter Width = 8) (
    input logic [Width-1:0] a,
    input logic [Width-1:0] b,
    input logic [2:0]       alu_op,
    output logic [Width-1:0] result,
    output logic            zero,
    output logic            carry_out,
    output logic            overflow,
    output logic            negative
);

    logic [Width:0] full_result; // extra bit to capture carry


    always_comb begin 
        full_result = '0;

        case (alu_op)
            3'b000: full_result = {1'b0, a} + {1'b0, b};    //Add
            3'b001: full_result = {1'b0, a} - {1'b0, b};    //Sub
            3'b010: full_result = {1'b0, a & b};            //AND
            3'b011: full_result = {1'b0, a | b};            //OR
            3'b100: full_result = {1'b0, a ^ b};            //XOR
            3'b101: full_result = {1'b0, ~a};               //NOT
            3'b110: full_result = {1'b0, a << 1};           //SLL
            3'b111: full_result = {1'b0, a >> 1};           //SRL
            default: full_result = '0;
        endcase
        
    end

    assign result = full_result[Width-1:0];
    assign carry_out = full_result[Width];
    assign zero = (result == '0);
    assign negative = result[Width - 1];
    
    assign overflow = (alu_op == 3'b000) ? (~a[Width-1] & ~b[Width-1] &  result[Width-1]) |
                                             ( a[Width-1] &  b[Width-1] & ~result[Width-1])
                     : (alu_op == 3'b001) ? (~a[Width-1] &  b[Width-1] &  result[Width-1]) |
                                             ( a[Width-1] & ~b[Width-1] & ~result[Width-1])
                     : 1'b0;
endmodule