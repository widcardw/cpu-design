// `include "./alu/mux2to1.v"
// `include "./instruction_fetch/InstructionMem.v"

module InstructionFetch
(
    Clk, Run,
    Zero, Branch, Jump,
    Instruction
);
    input Clk, Run, Branch, Jump, Zero;
    output [31:0] Instruction;
    wire [29:0] PC_1, ImmExt, PC_1_Ext, BranchResult, JumpIn, Newpc;
	reg [29:0] PC;

    assign PC_1 = PC + 30'b1;
    assign PC_1_Ext = PC_1 + ImmExt;
    assign ImmExt = {{14{Instruction[15]}}, Instruction[15:0]};
    assign JumpIn = {PC[29:26], Instruction[25:0]};

    mux2to1 #(.k(30))
    mux1 (
        .V(PC_1), 
        .W(PC_1_Ext), 
        .Selm(Branch & Zero), 
        .F(BranchResult)
    );
    mux2to1 #(.k(30))
    mux2 (
        .V(BranchResult), 
        .W(JumpIn), 
        .Selm(Jump), 
        .F(Newpc)
    );
    
    InstructionMem mem(
        .addr({PC, 2'b0}), 
        .Instruction(Instruction)
    );

    always @(negedge Clk) begin
        if (Run == 1'b1) begin
            PC <= Newpc;
        end
    end

    initial begin
        PC <= 0;
    end
endmodule


