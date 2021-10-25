module pc # (
        parameter initial_addr = 32'h0000_0000
    )
    (
        input               clk,
        input               run,
        input       [31:0]  newpc,
        output  reg [31:0]  pc
    );

    initial begin
        pc <= initial_addr;
    end

    always @(negedge clk) begin
        if (run == 1'b1) begin
            pc <= newpc;
        end
    end

endmodule
