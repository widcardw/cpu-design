`include "./src/datapath.v"
`include "./src/controller.v"
module pipeline1 (
        input clk,
        input run
    );

    // datapath unit

    wire    [31:0]  Instruction;

    wire            ctrl_RegWr;
    wire            ctrl_ExtOp;
    wire            ctrl_RegDst;
    wire    [2:0]   ctrl_ALUOp;
    wire            ctrl_ALUSrc;
    wire            ctrl_Branch;
    wire            ctrl_MemWr;
    wire            ctrl_MemtoReg;
    wire            ctrl_R_type;
    wire            ctrl_Jump;

    datapath u_datapath(
                 // input
                 .clk           (clk),
                 .run           (run),
                 .RegWr         (ctrl_RegWr),
                 .RegDst        (ctrl_ExtOp),
                 .ExtOp         (ctrl_RegDst),
                 .ALUOp         (ctrl_ALUOp),
                 .ALUSrc        (ctrl_ALUSrc),
                 .Branch        (ctrl_Branch),
                 .MemWr         (ctrl_MemWr),
                 .MemtoReg      (ctrl_MemtoReg),
                 .Jump          (ctrl_Jump),

                 // output
                 .Instruction   (Instruction)
             );

    // controller unit



    controller u_controller(
                   // input
                   .Instruction (Instruction),

                   // output
                   .RegWr       (ctrl_RegWr),
                   .ALUSrc      (ctrl_ALUSrc),
                   .RegDst      (ctrl_RegDst),
                   .MemtoReg    (ctrl_MemtoReg),
                   .MemWr       (ctrl_MemWr),
                   .Branch      (ctrl_Branch),
                   .Jump        (ctrl_Jump),
                   .ExtOp       (ctrl_ExtOp),
                   .ALUctr      (ctrl_ALUOp),
                   .R_type      (ctrl_R_type)
               );
endmodule //pipeline1
