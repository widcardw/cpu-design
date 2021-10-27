module mux2to1 #(
        parameter k = 8
    )  (
        input       [k-1:0] A,
        input       [k-1:0] B,
        input               Selm,
        output  reg [k-1:0] R
    );

    always @(A or B or Selm)
        if (Selm == 0)
            R <= A;
        else
            R <= B;
endmodule

