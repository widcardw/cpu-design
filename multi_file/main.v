module main ();
    reg clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
        clock = 0;
        #60 $finish;
    end

    always #10 clock = ~clock;

    v1 u_v1(
        .clock 		( clock 		)
    );

    v2 u_v2(
        .clock 		( clock 		)
    );

endmodule //main