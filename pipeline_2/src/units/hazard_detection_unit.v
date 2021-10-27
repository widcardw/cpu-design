module hazard_detection_unit (
        input   [4:0]   id_ex_Rt,
        input   [4:0]   if_id_Rs,
        input   [4:0]   if_id_Rt,
        input           id_ex_MemtoReg,
        output          stall_out
    );
    assign stall_out = id_ex_MemtoReg &&
           (id_ex_Rt == if_id_Rs || id_ex_Rt == if_id_Rt);
endmodule
