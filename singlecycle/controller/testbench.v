`timescale 10ns/10ns

module testbench(
    RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, R_type, ALUctr
);
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
        #500 $finish;
    end
    reg [31:0] Instruction;
    output wire RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, R_type;
    output wire [2:0] ALUctr;
    controller ctrller(
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
    initial begin
        Instruction <= 0;
        #10 Instruction <= 32'h00222820;
        #10 Instruction <= 32'h00222822;
        #10 Instruction <= 32'h00222823;
        #10 Instruction <= 32'h0022282A;
        #10 Instruction <= 32'h0022282B;
        #10 Instruction <= 32'h34220001;
        #10 Instruction <= 32'h24220001;
        #10 Instruction <= 32'h8c220001;
        #10 Instruction <= 32'hac220001;
        #10 Instruction <= 32'h10220002;
        #10 Instruction <= 32'h08000001;
        #10 Instruction <= 32'h0;
    end

endmodule
