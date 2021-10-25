module id_reg(
        // input
        input               Clk,
        input               stall,
        input               bubble,
        input               ExtOp,
        input               ALUSrc,
        input       [2:0]   ALUctr,
        input               RegDst,
        input               MemWr,
        input               Branch,
        input               MemtoReg,
        input               RegWr,
        input       [4:0]   Rt,
        input       [4:0]   Rd,
        input       [31:0]  busA,
        input       [31:0]  busB,
        input       [15:0]  imm,
        input       [31:0]  pc_inc,
        input               Jump,
        input       [31:0]  jump_target,
        // output
        output  reg         ExtOp_out,
        output  reg         ALUSrc_out,
        output  reg [2:0]   ALUctr_out,
        output  reg         RegDst_out,
        output  reg         MemWr_out,
        output  reg         Branch_out,
        output  reg         MemtoReg_out,
        output  reg         RegWr_out,
        output  reg [4:0]   Rt_out,
        output  reg [4:0]   Rd_out,
        output  reg [31:0]  busA_out,
        output  reg [31:0]  busB_out,
        output  reg [15:0]  imm_out,
        output  reg [31:0]  pc_inc_out,
        output  reg         Jump_out,
        output  reg [31:0]  jump_target_out
    );

    parameter RNONE = 0;

    always @ (posedge Clk) begin
        if (stall == 1'b1) begin
            ExtOp_out       <= ExtOp_out;
            ALUSrc_out      <= ALUSrc_out;
            ALUctr_out      <= ALUctr_out;
            RegDst_out      <= RegDst_out;
            Branch_out      <= Branch_out;
            MemWr_out       <= MemWr_out;
            MemtoReg_out    <= MemtoReg_out;
            RegWr_out       <= RegWr_out;
            Rt_out          <= Rt_out;
            Rd_out          <= Rd_out;
            busA_out        <= busA_out;
            busB_out        <= busB_out;
            imm_out         <= imm_out;
            pc_inc_out      <= pc_inc_out;
            Jump_out        <= Jump_out;
            jump_target_out <= jump_target_out;
        end
        else if (bubble == 1'b1) begin
            ExtOp_out       <= RNONE;
            ALUSrc_out      <= RNONE;
            ALUctr_out      <= RNONE;
            RegDst_out      <= RNONE;
            Branch_out      <= RNONE;
            MemWr_out       <= RNONE;
            MemtoReg_out    <= RNONE;
            RegWr_out       <= RNONE;
            Rt_out          <= RNONE;
            Rd_out          <= RNONE;
            busA_out        <= RNONE;
            busB_out        <= RNONE;
            imm_out         <= RNONE;
            pc_inc_out      <= RNONE;
            Jump_out        <= RNONE;
            jump_target_out <= RNONE;
        end
        else begin
            ExtOp_out       <= ExtOp;
            ALUSrc_out      <= ALUSrc;
            ALUctr_out      <= ALUctr;
            RegDst_out      <= RegDst;
            Branch_out      <= Branch;
            MemWr_out       <= MemWr;
            MemtoReg_out    <= MemtoReg;
            RegWr_out       <= RegWr;
            Rt_out          <= Rt;
            Rd_out          <= Rd;
            busA_out        <= busA;
            busB_out        <= busB;
            imm_out         <= imm;
            pc_inc_out      <= pc_inc;
            Jump_out        <= Jump;
            jump_target_out <= jump_target;
        end
    end

    initial begin
        ExtOp_out       <= RNONE;
        ALUSrc_out      <= RNONE;
        ALUctr_out      <= RNONE;
        RegDst_out      <= RNONE;
        Branch_out      <= RNONE;
        MemWr_out       <= RNONE;
        MemtoReg_out    <= RNONE;
        RegWr_out       <= RNONE;
        Rt_out          <= RNONE;
        Rd_out          <= RNONE;
        busA_out        <= RNONE;
        busB_out        <= RNONE;
        imm_out         <= RNONE;
        pc_inc_out      <= RNONE;
        Jump_out        <= RNONE;
        jump_target_out <= RNONE;
    end

endmodule
