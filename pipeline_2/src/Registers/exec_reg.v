module exec_reg(
        // input
        input               Clk,
        input               stall,
        input               bubble,
        input               MemWr,
        input               Branch,
        input               MemtoReg,
        input               RegWr,
        input       [31:0]  Target,
        input               Zero,
        input       [31:0]  ALUout,
        input       [31:0]  busB,
        input       [4:0]   Rw,
        input               Jump,
        input       [31:0]  jump_target,
        // output
        output  reg         MemWr_out,
        output  reg         Branch_out,
        output  reg         MemtoReg_out,
        output  reg         RegWr_out,
        output  reg [31:0]  Target_out,
        output  reg         Zero_out,
        output  reg [31:0]  ALUout_out,
        output  reg [31:0]  busB_out,
        output  reg [4:0]   Rw_out,
        output  reg         Jump_out,
        output  reg [31:0]  jump_target_out
    );

    parameter RNONE = 0;

    always @(posedge Clk) begin
        if (stall == 1'b1) begin
            MemWr_out       <= MemWr_out;
            Branch_out      <= Branch_out;
            MemtoReg_out    <= MemtoReg_out;
            RegWr_out       <= RegWr_out;
            Target_out      <= Target_out;
            Zero_out        <= Zero_out;
            ALUout_out      <= ALUout_out;
            busB_out        <= busB_out;
            Rw_out          <= Rw_out;
            Jump_out        <= Jump_out;
            jump_target_out <= jump_target_out;
        end
        else if (bubble == 1'b1) begin
            MemWr_out       <= RNONE;
            Branch_out      <= RNONE;
            MemtoReg_out    <= RNONE;
            RegWr_out       <= RNONE;
            Target_out      <= RNONE;
            Zero_out        <= RNONE;
            ALUout_out      <= RNONE;
            busB_out        <= RNONE;
            Rw_out          <= RNONE;
            Jump_out        <= RNONE;
            jump_target_out <= RNONE;
        end
        else begin
            MemWr_out       <= MemWr;
            Branch_out      <= Branch;
            MemtoReg_out    <= MemtoReg;
            RegWr_out       <= RegWr;
            Target_out      <= Target;
            Zero_out        <= Zero;
            ALUout_out      <= ALUout;
            busB_out        <= busB;
            Rw_out          <= Rw;
            Jump_out        <= Jump;
            jump_target_out <= jump_target;
        end
    end

    initial begin
        MemWr_out       <= RNONE;
        Branch_out      <= RNONE;
        MemtoReg_out    <= RNONE;
        RegWr_out       <= RNONE;
        Target_out      <= RNONE;
        Zero_out        <= RNONE;
        ALUout_out      <= RNONE;
        busB_out        <= RNONE;
        Rw_out          <= RNONE;
        Jump_out        <= RNONE;
        jump_target_out <= RNONE;
    end

endmodule
