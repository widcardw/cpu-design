module bz_signal_unit (
    input clk,
    input run,
    input branch,
    // input zero,
    // output reg bz,
    output reg branch_reg 
);
    // always @(negedge clk) begin
    //     if (run == 1'b1) begin
    //         if (branch_reg == 1'b1 && zero == 1'b1) begin
    //             bz <= 1;
    //         end
    //         else begin
    //             bz <= 0;
    //         end
    //     end
    // end

    initial begin
        // bz <= 0;
        branch_reg <= branch;
    end

    always @(negedge clk) begin
        branch_reg <= branch;
    end

endmodule //bz_signal_unit