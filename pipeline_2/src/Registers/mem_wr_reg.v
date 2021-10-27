module mem_wr_reg (
        // input
        input               Clk,
        input               stall,
        input               bubble,
        input       [31:0]  Dataout,
        input       [4:0]   Rw,
        input       [31:0]  ALUout,
        input               MemtoReg,
        input               RegWr,
        // output
        output  reg [31:0]  Dataout_out,
        output  reg [4:0]   Rw_out,
        output  reg [31:0]  ALUout_out,
        output  reg         MemtoReg_out,
        output  reg         RegWr_out
    );

    parameter RNONE = 0;

    always @(posedge Clk) begin
        if (stall == 1'b1) begin
            Dataout_out     <= Dataout_out;
            Rw_out          <= Rw_out;
            ALUout_out      <= ALUout_out;
            MemtoReg_out    <= MemtoReg_out;
            RegWr_out       <= RegWr_out;
        end
        else if (bubble == 1'b1) begin
            Dataout_out     <= RNONE;
            Rw_out          <= RNONE;
            ALUout_out      <= RNONE;
            MemtoReg_out    <= RNONE;
            RegWr_out       <= RNONE;
        end
        else begin
            Dataout_out     <= Dataout;
            Rw_out          <= Rw;
            ALUout_out      <= ALUout;
            MemtoReg_out    <= MemtoReg;
            RegWr_out       <= RegWr;
        end
    end

    initial begin
        Dataout_out     <= RNONE;
        Rw_out          <= RNONE;
        ALUout_out      <= RNONE;
        MemtoReg_out    <= RNONE;
        RegWr_out       <= RNONE;
    end

endmodule //mem_wr_reg
