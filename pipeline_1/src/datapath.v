`include "./src/Registers/if_reg.v"
`include "./src/Registers/id_reg.v"
`include "./src/Registers/exec_reg.v"
`include "./src/Registers/mem_wr_reg.v"
`include "./src/units/adderk.v"
`include "./src/units/alu_dispatcher.v"
`include "./src/units/alu.v"
`include "./src/units/mux3to1.v"
`include "./src/units/mux2to1.v"
`include "./src/units/datamem.v"
`include "./src/units/exec_unit.v"
`include "./src/units/extender.v"
`include "./src/units/insmem.v"
`include "./src/units/iunit.v"
`include "./src/units/rfile.v"
`include "./src/units/split_instruction.v"
`include "./src/units/pc.v"

module datapath (
        input               clk,
        input               run,
        input               RegWr,
        input               RegDst,
        input               ExtOp,
        input       [2:0]   ALUOp,  // ALUctr
        input               ALUSrc,
        input               Branch,
        input               MemWr,
        input               MemtoReg,
        input               Jump,
        output      [31:0]  Instruction
    );

    // before IF module

    wire [31:0] m_bz_newpc;
    wire [31:0] m_real_newpc;
    wire [31:0] u_pc_pc_out;         // output by pc unit

    wire [31:0] pc_inc_out;     // output by iunit

    pc # (
           .initial_addr    (32'h0000_0000)
       ) u_pc (
           .clk             (clk),
           .run             (run),
           .newpc           (m_real_newpc),
           .pc              (u_pc_pc_out)
       );

    iunit u_iunit (
              .pc           (u_pc_pc_out),
              .Clk          (clk),
              .Run          (run),
              .pc_out       (pc_inc_out),
              .Instruction  (Instruction)
          );

    // branch & zero mux

    mux2to1 # (
                .k          (32)
            ) mux_bz_newpc (
                .A          (pc_inc_out),
                .B          (ex_me_Target_out),   // Branch new pc
                .Selm       (ex_me_bz),     // Branch & Zero
                .R          (m_bz_newpc)
            );

    // jump mux

    mux2to1 # (
                .k          (32)
            ) mux_jump_newpc (
                .A          (m_bz_newpc),
                .B          (ex_me_jump_target),
                .Selm       (ex_me_jump),
                .R          (m_real_newpc)
            );

    // IF_ID reg

    wire            if_id_bubble;
    wire            if_id_stall;

    assign          if_id_bubble = 0;
    assign          if_id_stall = 0;

    wire    [31:0]  if_id_pc_inc_out;       // output by if_id_reg
    wire    [31:0]  if_id_instruction_out;  // output by if_id_reg

    if_reg # (
               .RNONE               (0)
           ) r_if_reg(
               .Clk                 (clk),
               .bubble              (if_id_bubble),
               .stall               (if_id_stall),
               .pc_inc              (pc_inc_out),
               .instruction         (Instruction),
               .pc_inc_out          (if_id_pc_inc_out),
               .instruction_out     (if_id_instruction_out)
           );

    // the main controller would follow the if_id_reg
    // the controller receives Instructions and Decodes them into state signals
    // however, the main controller will be declared outside of datapath
    // and datapath would receive the signals and pass them into registers

    // jump target

    wire    [31:0]  jump_target_pc;

    assign jump_target_pc = {u_pc_pc_out[31:28], Instruction[25:0], 2'b00};

    // mux2to1 # (
    //             .k      (32)
    //         ) mux_real_pc (
    //             .A      (m_bz_newpc),
    //             .B      (jump_target_pc),
    //             .Selm   (Jump),
    //             .R      (m_real_newpc)
    //         );

    // Instruction split, before signals are passed into rfile

    wire    [4:0]   si_Rs;
    wire    [4:0]   si_Rt;
    wire    [4:0]   si_Rd;
    wire    [15:0]  si_im;

    split_instruction u_si(
                          .Instruction  (if_id_instruction_out),
                          .Rs           (si_Rs),
                          .Rt           (si_Rt),
                          .Rd           (si_Rd),
                          .im           (si_im)
                      );

    // unit RFile

    wire    [31:0]  rfile_busA;
    wire    [31:0]  rfile_busB;

    rfile u_rfile(
              .Clk      (clk),
              .Run      (run),
              .Rs       (si_Rs),
              .Rt       (si_Rt),
              .Rw       (me_wr_Rw_out),  // wait for callback by MemWr Reg
              .RegWr    (RegWr),
              .busW     (me_wr_databack),  // wait for Datain by MemWr Reg
              .busA     (rfile_busA),
              .busB     (rfile_busB)
          );

    // ID_Ex_Register

    wire            id_ex_stall;
    wire            id_ex_bubble;

    assign          id_ex_stall = 0;
    assign          id_ex_bubble = 0;

    wire            id_ex_ExtOp_out;
    wire            id_ex_ALUSrc_out;
    wire    [2:0]   id_ex_ALUOp_out;
    wire            id_ex_RegDst_out;
    wire            id_ex_MemWr_out;
    wire            id_ex_Branch_out;
    wire            id_ex_MemtoReg_out;
    wire            id_ex_RegWr_out;
    wire    [4:0]   id_ex_Rt_out;
    wire    [4:0]   id_ex_Rd_out;
    wire    [31:0]  id_ex_busA_out;
    wire    [31:0]  id_ex_busB_out;
    wire    [15:0]  id_ex_imm_out;
    wire    [31:0]  id_ex_pc_inc_out;
    wire            id_ex_jump;
    wire    [31:0]  id_ex_jump_target;

    id_reg # (
               .RNONE               (0)
           ) r_id_reg(
               .Clk             (clk),
               .stall           (id_ex_stall),
               .bubble          (id_ex_bubble),

               .ExtOp           (ExtOp),
               .ALUSrc          (ALUSrc),
               .ALUctr          (ALUOp),
               .RegDst          (RegDst),
               .MemWr           (MemWr),
               .Branch          (Branch),
               .MemtoReg        (MemtoReg),
               .RegWr           (RegWr),
               .Rt              (si_Rt),
               .Rd              (si_Rd),
               .busA            (rfile_busA),
               .busB            (rfile_busB),
               .imm             (si_im),
               .pc_inc          (if_id_pc_inc_out),
               .Jump            (Jump),
               .jump_target     (jump_target_pc),

               .ExtOp_out       (id_ex_ExtOp_out),
               .ALUSrc_out      (id_ex_ALUSrc_out),
               .ALUctr_out      (id_ex_ALUOp_out),
               .RegDst_out      (id_ex_RegDst_out),
               .MemWr_out       (id_ex_MemWr_out),
               .Branch_out      (id_ex_Branch_out),
               .MemtoReg_out    (id_ex_MemtoReg_out),
               .RegWr_out       (id_ex_RegWr_out),
               .Rt_out          (id_ex_Rt_out),
               .Rd_out          (id_ex_Rd_out),
               .busA_out        (id_ex_busA_out),
               .busB_out        (id_ex_busB_out),
               .imm_out         (id_ex_imm_out),
               .pc_inc_out      (id_ex_pc_inc_out),
               .Jump_out        (id_ex_jump),
               .jump_target_out (id_ex_jump_target)
           );

    // mux Rt and Rd by RegDst

    wire    [4:0]   m_rt_rd_Rw;

    mux2to1 # (
                .k (5)
            ) m_rt_rd (
                .A      (id_ex_Rt_out),
                .B      (id_ex_Rd_out),
                .Selm   (id_ex_RegDst_out),
                .R      (m_rt_rd_Rw)
            );

    // exec unit

    wire    [31:0]  u_exec_alu_result;
    wire            u_exec_alu_zero;
    wire    [31:0]  u_exec_target;

    exec_unit u_exec(
                  .pc_inc   (id_ex_pc_inc_out),
                  .busA     (id_ex_busA_out),
                  .busB     (id_ex_busB_out),
                  .imm      (id_ex_imm_out),
                  .ExtOp    (id_ex_ExtOp_out),
                  .ALUSrc   (id_ex_ALUSrc_out),
                  .ALUctr   (id_ex_ALUOp_out),
                  .ALUout   (u_exec_alu_result),
                  .Zero     (u_exec_alu_zero),
                  .Target   (u_exec_target)
              );

    // Ex/Mem Register

    wire            ex_me_stall;
    wire            ex_me_bubble;

    assign          ex_me_stall = 0;
    assign          ex_me_bubble = 0;

    wire            ex_me_MemWr_out;
    wire            ex_me_Branch_out;
    wire            ex_me_MemtoReg_out;
    wire            ex_me_RegWr_out;
    wire    [31:0]  ex_me_Target_out;
    wire            ex_me_Zero_out;
    wire    [31:0]  ex_me_ALUout_out;
    wire    [31:0]  ex_me_busB_out;
    wire    [4:0]   ex_me_Rw_out;
    wire            ex_me_jump;
    wire    [31:0]  ex_me_jump_target;

    exec_reg # (
                 .RNONE               (0)
             ) r_exec_mem(
                 .Clk               (clk),
                 .stall             (ex_me_stall),
                 .bubble            (ex_me_bubble),
                 .MemWr             (id_ex_MemWr_out),
                 .Branch            (id_ex_Branch_out),
                 .MemtoReg          (id_ex_MemtoReg_out),
                 .RegWr             (id_ex_RegWr_out),
                 .Target            (u_exec_target),
                 .Zero              (u_exec_alu_zero),
                 .ALUout            (u_exec_alu_result),
                 .busB              (id_ex_busB_out),
                 .Rw                (m_rt_rd_Rw),
                 .Jump              (id_ex_jump),
                 .jump_target       (id_ex_jump_target),

                 .MemWr_out         (ex_me_MemWr_out),
                 .Branch_out        (ex_me_Branch_out),
                 .MemtoReg_out      (ex_me_MemtoReg_out),
                 .RegWr_out         (ex_me_RegWr_out),
                 .Target_out        (ex_me_Target_out),
                 .Zero_out          (ex_me_Zero_out),
                 .ALUout_out        (ex_me_ALUout_out),
                 .busB_out          (ex_me_busB_out),
                 .Rw_out            (ex_me_Rw_out),
                 .Jump_out          (ex_me_jump),
                 .jump_target_out   (ex_me_jump_target)
             );

    // Branch & Zero signal

    wire            ex_me_bz;

    assign ex_me_bz = ex_me_Branch_out & ex_me_Zero_out;

    // DataMem unit

    wire    [31:0]  u_datamem_dataout;

    datamem u_datamem(
                .Clk            (clk),
                .Run            (run),
                .MemWr          (ex_me_MemWr_out),
                .ReadAddr       (ex_me_ALUout_out),
                .WriteAddr      (ex_me_ALUout_out),
                .Datain         (ex_me_busB_out),
                .Dataout        (u_datamem_dataout)
            );

    // Mem/Wr Reg

    wire            me_wr_stall;
    wire            me_wr_bubble;

    assign          me_wr_stall = 0;
    assign          me_wr_bubble = 0;

    wire    [31:0]  me_wr_Dataout_out;
    wire    [4:0]   me_wr_Rw_out;
    wire    [31:0]  me_wr_ALUout_out;
    wire            me_wr_MemtoReg_out;
    wire            me_wr_RegWr_out;

    mem_wr_reg # (
                   .RNONE               (0)
               ) r_mem_wr(
                   .Clk             (clk),
                   .stall           (me_wr_stall),
                   .bubble          (me_wr_bubble),
                   .Dataout         (u_datamem_dataout),
                   .Rw              (ex_me_Rw_out),
                   .ALUout          (ex_me_ALUout_out),
                   .MemtoReg        (ex_me_MemtoReg_out),
                   .RegWr           (ex_me_RegWr_out),

                   .Dataout_out     (me_wr_Dataout_out),
                   .Rw_out          (me_wr_Rw_out),
                   .ALUout_out      (me_wr_ALUout_out),
                   .MemtoReg_out    (me_wr_MemtoReg_out),
                   .RegWr_out       (me_wr_RegWr_out)
               );

    // Mem to Reg write back

    wire    [31:0]  me_wr_databack;

    mux2to1 #(
                .k      (32)
            )
            m_mem_to_reg(
                .A      (me_wr_ALUout_out),
                .B      (me_wr_Dataout_out),
                .Selm   (me_wr_MemtoReg_out),
                .R      (me_wr_databack)
            );

    // initialize all of the wires

    /*initial begin
        m_bz_newpc              = 0;
        m_real_newpc            = 0;
        u_pc_pc_out             = 0;
        pc_inc_out              = 0;
        if_id_bubble            = 0;
        if_id_stall             = 0;
        if_id_pc_inc_out        = 0;
        if_id_instruction_out   = 0;
        jump_target_pc          = 0;
        si_Rs                   = 0;
        si_Rt                   = 0;
        si_Rd                   = 0;
        si_im                   = 0;
        rfile_busA              = 0;
        rfile_busB              = 0;
        id_ex_stall             = 0;
        id_ex_bubble            = 0;
        id_ex_ExtOp_out         = 0;
        id_ex_ALUSrc_out        = 0;
        id_ex_ALUOp_out         = 0;
        id_ex_RegDst_out        = 0;
        id_ex_MemWr_out         = 0;
        id_ex_Branch_out        = 0;
        id_ex_MemtoReg_out      = 0;
        id_ex_RegWr_out         = 0;
        id_ex_Rt_out            = 0;
        id_ex_Rd_out            = 0;
        id_ex_busA_out          = 0;
        id_ex_busB_out          = 0;
        id_ex_imm_out           = 0;
        id_ex_pc_inc_out        = 0;
        id_ex_jump              = 0;
        id_ex_jump_target       = 0;
        m_rt_rd_Rw              = 0;
        u_exec_alu_result       = 0;
        u_exec_alu_zero         = 0;
        u_exec_target           = 0;
        ex_me_stall             = 0;
        ex_me_bubble            = 0;
        ex_me_MemWr_out         = 0;
        ex_me_Branch_out        = 0;
        ex_me_MemtoReg_out      = 0;
        ex_me_RegWr_out         = 0;
        ex_me_Target_out        = 0;
        ex_me_Zero_out          = 0;
        ex_me_ALUout_out        = 0;
        ex_me_busB_out          = 0;
        ex_me_Rw_out            = 0;
        ex_me_jump              = 0;
        ex_me_jump_target       = 0;
        ex_me_bz                = 0;
        u_datamem_dataout       = 0;
        me_wr_stall             = 0;
        me_wr_bubble            = 0;
        me_wr_Dataout_out       = 0;
        me_wr_Rw_out            = 0;
        me_wr_ALUout_out        = 0;
        me_wr_MemtoReg_out      = 0;
        me_wr_RegWr_out         = 0;
        me_wr_databack          = 0;
    end*/
endmodule //datapath

// DONE

// we need to add the instruction JUMP
// the signal of JUMP is generated by the main controller
// and the target pc is {PC[31:28], instruction[25:0], 2'b00}
// if the JUMP signal is enabled, the next pc would be changed into JUMP TARGET PC
