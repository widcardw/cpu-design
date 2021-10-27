module iunit(
        input       [31:0]  pc,
        input               Clk,
        input               Run,

        output      [31:0]  pc_out,
        output      [31:0]  Instruction
    );

    assign pc_out = pc + 4;

    insmem instructionMem(
               .clk         (Clk),
               .run         (Run),
               .addr        (pc),
               .Instruction (Instruction)
           );

endmodule
