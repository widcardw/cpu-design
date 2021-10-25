module exec_unit(
        input       [31:0]  pc_inc,
        input       [31:0]  busA,
        input       [31:0]  busB,
        input       [15:0]  imm,
        input               ExtOp,
        input               ALUSrc,
        input       [2:0]   ALUctr,
        
        output      [31:0]  ALUout,
        output              Zero,
        output      [31:0]  Target
    );

    wire        [31:0]  imm32;
    wire        [31:0]  ALUinB;
    wire                overflow;

    extender ext(
                 .im     (imm),
                 .Im     (imm32),
                 .ExtOp  (ExtOp)
             );

    mux2to1 #(.k    (32))
            muxALUinB(
                .A      (busB),
                .B      (imm32),
                .Selm   (ALUSrc),
                .R      (ALUinB)
            );

    alu ALU(
            .input_a        (busA),
            .input_b        (ALUinB),
            .input_aluctr   (ALUctr),
            .out_result     (ALUout),
            .out_zero       (Zero),
            .out_overflow   (overflow)
        );

    assign Target = (imm32 << 2) + pc_inc;

endmodule
