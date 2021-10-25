`timescale 10ns/10ns
module testbench();
    reg                 Clk;
    reg                 Run;
    reg     [31: 0]     DataIn;
    wire    [31: 0]     DataOut;
    reg     [31: 0]     Addr;
    reg                 MemWr;

    data_mem mem1(
                 .Run    (Run),
                 .Clk    (Clk),
                 .MemWr  (MemWr),
                 .Addr   (Addr),
                 .data_input     (DataIn),
                 .data_output    (DataOut)
             );

    initial begin
        Clk <= 1'b1;
        MemWr <= 1'b0;
        Addr <= 0;
        DataIn <= 0;
        Run <= 1'b0;
        #10     Run <= 1'b1;
        #50     DataIn <= 32'h987;
        #50     Addr <= 5'h4;
        #50     MemWr <= 1'b1;

        #80     DataIn <= 32'h0;
        #80     Addr <= 5'h3;
        #80     MemWr <= 1'b0;

        #110    Addr <= 5'h1;

        #140    Addr <= 5'h2;

        #5000 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    always begin
        #10 Clk = !Clk;
    end
endmodule
