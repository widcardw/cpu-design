`timescale 10ns/10ns

module testbench();

    initial begin
        A <= 31;
        B <= 24;
        ALUctr <= 0;
        $dumpfile("wave.vcd");
        $dumpvars;
        #5000 $finish;
    end

    reg [31:0] A, B, Result;
    reg [2:0]  ALUctr;
    wire zero, ov;

    alu #(
        .n  (32)
    )
    test_alu(
        .input_a(A),
        .input_b(B),
        .input_aluctr(ALUctr),
        .out_result(Result),
        .out_zero(zero),
        .out_overflow(ov)
    );

    always begin
        #10 ALUctr <= ALUctr + 1'b1;
    end


endmodule
