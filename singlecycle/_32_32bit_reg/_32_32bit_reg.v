// `include "./alu/mux2to1.v"

module _32_32bit_reg(
    Rs,
    Rt,
    Rd,
    RegDst,
    busA,
    busB,
    busW,
    RegWr,
    Run,
    Overflow,
    Clk
);
    input   [ 4: 0]     Rs, Rt, Rd;
    input               RegDst;
    input   [31: 0]     busW;
    input               Run;
    input               RegWr;
    input               Overflow;
    input               Clk;

    output  reg [31: 0] busA, busB;

    reg     [31: 0]     Mem [31:0];

    wire    [ 4: 0]     Ra, Rb, Rw;
    wire                RealRegWr;

    assign Ra = Rs;
    assign Rb = Rt;
    assign RealRegWr = RegWr & ~Overflow;

    mux2to1 #(
        .k      (5)
    )
    muxRegDst(
        .V      (Rt),
        .W      (Rd),
        .Selm   (RegDst),
        .F      (Rw)
    );

    always @(negedge Clk) begin
        if (Run == 1'b1) begin
            if (RealRegWr == 1'b1) begin
                Mem[Rw] = busW;
            end
        end
    end

    always @(Ra or Rb or Run) begin
        if (Run == 1'b1) begin
            busA = Mem[Ra];
            busB = Mem[Rb];
        end
        else begin
            busA = 32'b0;
            busB = 32'b0;
        end
    end

endmodule
