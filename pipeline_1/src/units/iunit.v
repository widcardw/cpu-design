module iunit(
        input       [31:0]  pc,
        input               Clk,
        input               Run,
        // input               nextSel,
        // input       [31:0]  branch_pc,
        output      [31:0]  pc_out,
        output      [31:0]  Instruction
    );

    // reg         [31:0]  pc;
    // wire        [31:0]  newpc;

    assign pc_out = pc + 4;

    insmem instructionMem(
               .clk         (Clk),
               .run         (Run),
               .addr        (pc),
               .Instruction (Instruction)
           );

    // mux2to1  #(
    //              .k     (32)
    //          )
    //          m (
    //              .A         (pc_out),
    //              .B         (branch_pc),
    //              .Selm      (nextSel),
    //              .R         (newpc)
    //          );

endmodule
