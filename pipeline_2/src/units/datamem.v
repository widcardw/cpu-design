module datamem (
        // input
        input               Clk,
        input               Run,
        input               MemWr,
        input       [31:0]  ReadAddr,
        input       [31:0]  WriteAddr,
        input       [31:0]  Datain,
        output reg  [31:0]  Dataout
    );

    reg         [31:0]  Mem [31:0];

    always @(posedge Clk) begin
        if (Run == 1'b1) begin
            if (MemWr == 1'b1) begin
                Mem[WriteAddr] <= Datain;
            end
        end
    end

    always @(negedge Clk) begin
        if (Run == 1'b1) begin
            Dataout <= Mem[ReadAddr];
        end
    end

    initial begin
        $readmemh("./src/Memory/datamem", Mem, 0, 31);
    end

endmodule //datamem
