module split_instruction(
        input   [31:0]  Instruction,
        output  [ 4:0]  Rs,
        output  [ 4:0]  Rt,
        output  [ 4:0]  Rd,
        output  [15:0]  im
    );

    assign Rs = Instruction[25:21];
    assign Rt = Instruction[20:16];
    assign Rd = Instruction[15:11];
    assign im = Instruction[15: 0];
endmodule
