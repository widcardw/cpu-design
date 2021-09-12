`include "./alu/mux3to1.v"
`include "./alu/mux2to1.v"
`include "./alu/adderk.v"
`include "./alu/alu_dispatcher.v"
`include "./alu/alu.v"
`include "./_32_32bit_reg/_32_32bit_reg.v"
`include "./controller/controller.v"
`include "./instruction_fetch/InstructionFetch.v"
`include "./instruction_fetch/InstructionMem.v"
`include "./memory/data_mem.v"
`include "./single_cycle_cpu/split_instruction.v"
`include "./single_cycle_cpu/extender.v"

module single_cycle_cpu(
    Run,
    Clk,
    Instruction,
    busA,
    busB,
    busW,
    Result
);
    input Run, Clk;
    output [31:0] Instruction;
    output [31:0] busA, busB, busW;
    output [31:0] Result;
    wire            RegWr;
    wire            MemWr;
    wire            MemtoReg;
    wire            RegDst;
    wire            Branch;
    wire            Jump;
    wire            ExtOp;
    wire            ALUSrc;
    wire    [2:0]   ALUctr;
    wire    [31:0]  busC;
    wire    [31:0]  DataOut;
    wire    [31:0]  Im;
    wire    [15:0]  im;
    wire    [4:0]   Rs;
    wire    [4:0]   Rt;
    wire    [4:0]   Rd;
    wire            Overflow;
    wire            Zero;
    wire            R_type;

    InstructionFetch IF (
        .Clk(Clk),
        .Run(Run),
        .Zero(Zero),
        .Branch(Branch),
        .Jump(Jump),
        .Instruction(Instruction)
    );

    split_instruction spi (
        .Instruction(Instruction),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd),
        .im(im)
    );

    extender ext (
        .im(im),
        .ExtOp(ExtOp),
        .Im(Im)
    );

    _32_32bit_reg _32reg (
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd),
        .RegDst(RegDst),
        .busA(busA),
        .busB(busB),
        .busW(busW),
        .RegWr(RegWr),
        .Run(Run),
        .Overflow(Overflow),
        .Clk(Clk)
    );

    data_mem dm (
        .Run(Run),
        .Clk(Clk),
        .MemWr(MemWr),
        .Addr(Result),
        .data_input(busB),
        .data_output(DataOut)
    );

    alu #(
        .n(32)
    ) 
    ALU (
        .input_a(busA),
        .input_b(busC),
        .input_aluctr(ALUctr),
        .out_result(Result),
        .out_zero(Zero),
        .out_overflow(Overflow)
    );

    mux2to1 #(
        .k(32)
    )
    muxb (
        .V(busB), 
        .W(Im), 
        .Selm(ALUSrc), 
        .F(busC)
    );

    mux2to1 #(
        .k(32)
    )
    muxmemreg (
        .V(Result),
        .W(DataOut),
        .Selm(MemtoReg),
        .F(busW)
    );

    controller ctrl (
        .Instruction(Instruction),
        .RegWr(RegWr),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .MemWr(MemWr),
        .Branch(Branch),
        .Jump(Jump),
        .ExtOp(ExtOp),
        .ALUctr(ALUctr),
        .R_type(R_type)
    );

endmodule