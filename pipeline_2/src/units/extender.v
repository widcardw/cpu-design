module extender (
        input   [15:0]  im,
        input           ExtOp,
        output  [31:0]  Im
    );

    assign Im = ExtOp == 1'b0 ? {16'b0, im} : {{16{im[15]}}, im};

endmodule //extender
