module rtl_adder
    (input  logic a, b, ci,
     output logic sum, co
    );

    assign {co, sum} = a + b + ci;

endmodule: rtl_adder