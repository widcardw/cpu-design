module adderk (
        carryin, X, Y,
        S,
        carryout, AddZero, AddOverflow, AddSign
    );
    parameter k = 8;
    input       [k-1:0]     X;
    input       [k-1:0]     Y;
    input                   carryin;
    output  reg [k-1:0]     S;
    output  reg             carryout;
    output  reg             AddZero;
    output  reg             AddOverflow;
    output  reg             AddSign;
    always@(X or Y or carryin) begin
        {carryout, S} = X + Y + carryin;
        AddZero = S == 0;
        AddOverflow = (X[k-1] & Y[k-1] & ~S[k-1]) |
                    (~X[k-1] & ~Y[k-1] & S[k-1]);
        AddSign = S[k-1];
    end
endmodule

