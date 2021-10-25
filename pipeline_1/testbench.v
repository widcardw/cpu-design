`timescale 10ns/10ns
`include "./src/pipeline1.v"

module tb_pipeline1();

    reg Clk;
    reg Run;

    pipeline1 u_pipeline1(
                  .clk(Clk),
                  .run(Run)
              );

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) Clk=~Clk;

    initial begin
        $dumpfile("tb_pipeline1.vcd");
        $dumpvars(0, tb_pipeline1);
    end

    initial begin
        Clk <= 0;
        Run <= 0;
        #10 Run <= 1;
        #500 $finish;
    end

endmodule //tb_pipeline1
