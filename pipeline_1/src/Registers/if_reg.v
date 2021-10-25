module if_reg(
        // input
        input               Clk,
        input               bubble,
        input               stall,
        input       [31:0]  pc_inc,
        input       [31:0]  instruction,
        //output
        output reg  [31:0]  pc_inc_out,
        output reg  [31:0]  instruction_out
    );

    parameter RNONE = 0;

    always @ (posedge Clk) begin
        if (stall == 1'b1) begin
            pc_inc_out <= pc_inc_out;
            instruction_out <= instruction_out;
        end 
        else if (bubble == 1'b1) begin
            pc_inc_out <= RNONE;
            instruction_out <= RNONE;
        end
        else begin
            pc_inc_out <= pc_inc;
            instruction_out <= instruction;
        end
    end

    initial begin
        pc_inc_out <= RNONE;
        instruction_out <= RNONE;
    end
endmodule
