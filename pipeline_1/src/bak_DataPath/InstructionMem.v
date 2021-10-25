module InstructionMem(addr, Instruction);
    input [31:0] addr;
    output [31:0] Instruction;
    localparam HIGH = 256;
    reg [7:0] Mem [HIGH-1:0];       // front means width, back means length

    assign Instruction = {Mem[3 + addr], Mem[2 + addr], Mem[1 + addr], Mem[addr]};
    initial begin
        // {Mem[3],  Mem[2],  Mem[1],  Mem[0] } = {6'b100011, 5'h00, 5'h08, 16'h0};
        // {Mem[7],  Mem[6],  Mem[5],  Mem[4] } = {6'h00, 5'h8, 5'h8, 5'h9, 5'h0, 6'h20};
        // {Mem[11], Mem[10], Mem[9],  Mem[8] } = {6'b100011, 5'h8, 5'ha, 16'b0};
        // {Mem[15], Mem[14], Mem[13], Mem[12]} = {6'b100011, 5'h9, 5'hb, 16'b0};
        // {Mem[19], Mem[18], Mem[17], Mem[16]} = {6'b000000, 5'hb, 5'ha, 5'hb, 5'b0, 6'b100000};
        // {Mem[23], Mem[22], Mem[21], Mem[20]} = {6'b101011, 5'h8, 5'hb, 16'h0};
        // {Mem[27], Mem[26], Mem[25], Mem[24]} = {6'b000100, 5'hb, 5'h0, 16'h3};
        // {Mem[31], Mem[30], Mem[29], Mem[28]} = {6'b000000, 5'hb, 5'ha, 5'hb, 5'b0, 6'b100010};
        // {Mem[35], Mem[34], Mem[33], Mem[32]} = {6'b000000, 5'hc, 5'hb, 5'hc, 5'b0, 6'b100000};
        // {Mem[39], Mem[38], Mem[37], Mem[36]} = {6'b000010, 26'h6};
        // {Mem[43], Mem[42], Mem[41], Mem[40]} = {6'b101011, 5'h0, 5'hc, 16'h2};
        $readmemh("./DataPath", Mem, 0, HIGH-1);
    end
endmodule
