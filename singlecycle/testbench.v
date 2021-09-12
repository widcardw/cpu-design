`timescale 10ns/10ns
`include "./single_cycle_cpu/single_cycle_cpu.v"

module tb_single_cycle_cpu;
    reg             Clk;
    reg             Run;
    wire    [31:0]  Instruction;
    wire    [31:0]  busA;
    wire    [31:0]  busB;
    wire    [31:0]  busW;
    wire    [31:0]  Result;

    single_cycle_cpu scc
    (
        .Run(Run),
        .Clk(Clk),
        .Instruction(Instruction),
        .busA(busA),
        .busB(busB),
        .busW(busW),
        .Result(Result)
    );

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) Clk=~Clk;

    initial begin
        $dumpfile("tb_single_cycle_cpu.vcd");
        $dumpvars(0, tb_single_cycle_cpu);
    end

    initial begin
        Clk <= 0;
        Run <= 0;
        #10 Run <= 1;
        #2000 $finish;
    end

endmodule