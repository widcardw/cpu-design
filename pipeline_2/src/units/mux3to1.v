module mux3to1 #(
        parameter k = 8
    )(
        input       [k-1:0] U,
        input       [k-1:0] V,
        input       [k-1:0] W,
        input       [1:0]   Sel,
        output  reg [k-1:0] F
    );

    always@(U or V or W or Sel) begin
        case (Sel)
            2'b00:
                F <= U;
            2'b01:
                F <= V;
            2'b10:
                F <= W;
        endcase
    end
endmodule

