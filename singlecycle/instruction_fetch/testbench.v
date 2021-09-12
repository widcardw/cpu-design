`timescale 10ns/10ns
`include "InstructionFetch.v"

module testbench();
    reg Clk;
    reg Run;
    reg Branch, Jump, Zero;
    wire [31:0] Instruction;
    InstructionFetch IF
    (
        .Clk(Clk),
        .Run(Run),
        .Zero(Zero),
        .Branch(Branch),
        .Jump(Jump),
        .Instruction(Instruction)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial begin
        Clk <= 1'b0;
        Zero <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        Run <= 1'b0;
        #10 Run <= 1'b1;
        #49 Branch <= 1; Zero <= 1;
        #21 Branch <= 0; Zero <= 0; 
        #99 Jump <= 1;
        #21 Jump <= 0;
        #500 $finish;
    end

    always begin
        #10 Clk <= !Clk;
    end

endmodule

