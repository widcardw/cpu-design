// `include "./alu/mux3to1.v"
// `include "./alu/mux2to1.v"
// `include "./alu/adderk.v"
// `include "./alu/alu_dispatcher.v"

module alu(
    input_a,
    input_b,
    input_aluctr,
    out_result,
    out_zero,
    out_overflow
);
    parameter n = 32;

    input   [n - 1: 0]  input_a, input_b;
    input   [    2: 0]  input_aluctr;

    output  [n - 1: 0]  out_result;
    output              out_zero, out_overflow;

    wire                Add_carry;
    wire                Add_overflow;
    wire                Add_sign;
    wire                Add_zero;
    wire    [n - 1: 0]  Add_result;
    wire                Subctr;
    wire                Ovctr;
    wire                SIGctr;
    wire                Less;
    wire    [    1: 0]  OPctr;
    wire                I;
    wire                J;
    wire    [n - 1: 0]  H;
    wire    [n - 1: 0]  G;

    assign   H          = input_b ^ {n{Subctr}};
    assign   I          = Subctr  ^ Add_carry;
    assign   J          = Add_overflow ^ Add_sign;
    assign out_overflow = Add_overflow & Ovctr;

    mux3to1 #(
        .k   (n)     //  param
    )
    multiplexer1(
        .U   (Add_result),          // input
        .V   (input_a | input_b),
        .W   (G),
        .Sel (OPctr),
        .F   (out_result)           // output
    );

    mux2to1 #(
        .k   (n)
    )
    multiplexer2(
        .V   (32'h0),
        .W   (32'h1),
        .Selm(Less),
        .F   (G)
    );

    mux2to1 #(
        .k   (1)
    )
    multiplexer3(
        .V   (I), 
        .W   (J), 
        .Selm(SIGctr), 
        .F   (Less)
    );

    adderk #(
        .k   (n)
    )
    n_adder(
        .carryin    (Subctr), 
        .X          (input_a), 
        .Y          (H), 
        .S          (Add_result), 
        .carryout   (Add_carry), 
        .AddZero    (Add_zero), 
        .AddOverflow(Add_overflow), 
        .AddSign    (Add_sign)
    );

    assign out_zero = input_aluctr == 3'b011 ? 1'b0 : Add_zero;

    alu_dispatcher d0(
        .ALUctr     (input_aluctr), 
        .SUBctr     (Subctr), 
        .OPctr      (OPctr), 
        .OVctr      (Ovctr), 
        .SIGctr     (SIGctr)
    );

endmodule

