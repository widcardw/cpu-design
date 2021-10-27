module forwarding_unit (
        input   [4:0]   id_ex_Rs,
        input   [4:0]   id_ex_Rt,
        input   [4:0]   ex_me_Rw,
        input           ex_me_wb,  // all of the write back signals
        input   [4:0]   me_wr_Rw,
        input           me_wr_wb,  // all of the write back signals

        output  [1:0]   forward_a,
        output  [1:0]   forward_b
    );

    // C1: dest reg is the src reg of next ins
    // C2: dest reg is the src reg of next next ins

    wire c1a;  // c1 write back to busA
    wire c1b;  // c1 write back to busB
    wire c2a;  // c2 write back to busA
    wire c2b;  // c2 write back to busB

    // some of the condition
    // assign c1a = ex_me_Rw == id_ex_Rs;
    // assign c1b = ex_me_Rw == id_ex_Rt;
    // assign c2a = me_wr_Rw == id_ex_Rs;
    // assign c2b = me_wr_Rw == id_ex_Rt;

    // the assignment over may cause errors when not writeback to Rw
    // or Rw equals zero
    // As a result, the condition is as below

    assign c1a = (ex_me_wb) && (ex_me_Rw != 0) && (ex_me_Rw == id_ex_Rs);
    assign c2a = (me_wr_wb) && (me_wr_Rw != 0) && (ex_me_Rw != id_ex_Rs) && (me_wr_Rw == id_ex_Rs);
    assign c1b = (ex_me_wb) && (ex_me_Rw != 0) && (ex_me_Rw == id_ex_Rt);
    assign c2b = (me_wr_wb) && (me_wr_Rw != 0) && (ex_me_Rw != id_ex_Rt) && (me_wr_Rw == id_ex_Rt);
    
    assign forward_a = {c1a, c2a};
    assign forward_b = {c1b, c2b};

endmodule //forwarding_unit
