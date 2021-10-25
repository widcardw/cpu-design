module rfile(
        input               Clk,
        input               Run,
        input       [4:0]   Rs,
        input       [4:0]   Rt,
        input       [4:0]   Rw,    // input address for Rw
        input               RegWr,
        input       [31:0]  busW,  // input data for Di

        output  reg [31:0]  busA,
        output  reg [31:0]  busB
    );

    reg         [31:0]  Mem [31:0];

    initial begin
        $readmemh("./src/Memory/reg", Mem, 0, 31);
    end

    // Read busA and busB
    always @(negedge Clk) begin
        busA <= Mem[Rs];
        busB <= Mem[Rt];
    end

    // Write Mem, half a cycle before Read
    always @(posedge Clk) begin
        if (Run == 1'b1) begin
            if (RegWr == 1'b1)
                Mem[Rw] <= busW;
        end
    end

endmodule
