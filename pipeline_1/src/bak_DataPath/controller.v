module controller(
        input [31:0] Instruction,
        output RegWr, //
        output ALUSrc,
        output RegDst, //
        output MemtoReg, //
        output MemWr, //
        output Branch, //
        output Jump, //
        output ExtOp, //
        output [2:0] ALUctr, //
        output R_type //
    );
    wire ori, addiu, lw, sw, beq, jump;
    wire [2:0] ALUop, ALUfunc;

    OpDecoder opd(
                  .op(Instruction[31:26]),
                  .R_type(R_type),
                  .ori(ori),
                  .addiu(addiu),
                  .lw(lw),
                  .sw(sw),
                  .beq(beq),
                  .jump(jump)
              );

    assign Branch   = beq;
    assign RegWr    = R_type | ori | addiu | lw;
    assign ALUop    = {beq, ori, R_type};
    assign ALUSrc   = ori | addiu | lw | sw;
    assign MemtoReg = lw;
    assign RegDst   = R_type;
    assign Jump     = jump;
    assign MemWr    = sw;
    assign ExtOp    = addiu | lw | sw;

    ALUDecoder alud(
                   .func(Instruction[5:0]),
                   .outCtr(ALUfunc)
               );
    assign ALUctr = R_type == 1'b1 ? ALUfunc : ALUop;
endmodule

module OpDecoder(op, R_type, ori, addiu, lw, sw, beq, jump);
    input [5:0] op;
    output R_type, ori, addiu, lw, sw, beq, jump;
    assign R_type   = op == 6'b000000;
    assign ori      = op == 6'b001101;
    assign addiu    = op == 6'b001001;
    assign lw       = op == 6'b100011;
    assign sw       = op == 6'b101011;
    assign beq      = op == 6'b000100;
    assign jump     = op == 6'b000010;
endmodule

module ALUDecoder(func, outCtr);
    input [5:0] func;
    output [2:0] outCtr;
    assign outCtr[2] = ~func[2] & func[1];
    assign outCtr[1] = func[3] & ~func[2] & func[1];
    assign outCtr[0] = (~func[3] & ~func[2] & ~func[1] & ~func[0]) |
           (~func[2] & func[1] & ~func[0]);
endmodule

