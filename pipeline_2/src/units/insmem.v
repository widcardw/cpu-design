module insmem(
        input               clk,
        input               run,
        input       [31:0]  addr,
        output  reg [31:0]  Instruction
    );
    localparam HIGH = 64;

    reg     [31:0]  Mem [HIGH-1:0];

    initial begin
        $readmemh("./src/Memory/insmem", Mem, 0, HIGH-1);
    end

    always @(negedge clk) begin
        if (run == 1'b1)
            Instruction <= Mem[addr[31:2]];
    end

    initial begin
        Instruction <= 32'b0;
    end
endmodule
