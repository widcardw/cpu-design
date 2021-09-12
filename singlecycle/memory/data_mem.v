module data_mem(
    Run,
    Clk,
    MemWr,
    Addr,
    data_input,
    data_output
);
    input                   Run;
    input                   MemWr;
    input                   Clk;
    input       [31: 0]     Addr;
    input       [31: 0]     data_input;

    output      [31: 0]     data_output;

    reg         [31: 0]     Mem     [31: 0];

    assign      data_output = Mem[Addr];

    always @(negedge Clk) begin
        if (Run == 1'b1) begin
            if (MemWr == 1'b1) begin
                Mem[Addr] <= data_input;
            end
        end
    end

    initial begin
        Mem[1] = 32'h123;
        Mem[2] = 32'h456;
        Mem[3] = 32'h789;
    end

endmodule