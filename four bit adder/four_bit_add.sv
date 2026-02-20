module bitAdd_4
(
    input logic [3:0]   a, b,
    input logic ci,
    output logic [3:0]   out,
    output logic co
);

assign {co, out} = a + b + ci;

endmodule