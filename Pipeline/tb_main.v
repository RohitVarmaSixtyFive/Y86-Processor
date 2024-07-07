`include "1main_fetch.v"
`include "2main_decode.v"
`include "3main_execute.v"
`include "4main_memory.v"
`include "5main_wb.v"
`include "6main_pipe_control.v"
`include "control.v"

module memory_tb();

    reg clk;
    reg [63:0] F_predPC;

    wire F_stall, D_stall, D_bubble, E_bubble, W_stall;
    wire set_cc;

    wire [63:0] f_predPC;

    wire [3:0] D_icode;
    wire [3:0] D_ifun;
    wire [3:0] D_rA;
    wire [3:0] D_rB;
    wire [63:0] D_valC;
    wire [63:0] D_valP;
    wire [3:0] D_stat;  //AOK|HLT|ADR|INS

    // wire [63:0] d_valA, d_valB;

    wire [3:0] d_srcA, d_srcB;

    wire [3:0] E_icode;
    wire [3:0] E_ifun;
    wire [3:0] E_srcA;
    wire [3:0] E_srcB;
    wire [63:0] E_valA;
    wire [63:0] E_valB;
    wire [63:0] E_valC;
    wire [3:0] E_dstE;
    wire [3:0] E_dstM;  
    wire [3:0] E_stat;  //AOK|HLT|ADR|INS

    wire [3:0] M_icode;    
    wire [63:0] M_valA;
    wire [63:0] M_valM;
    wire [63:0] M_valE;
    wire [3:0] M_dstM;
    wire [3:0] M_dstE;
    wire M_Cnd;
    wire[3:0] M_stat;
    wire [63:0] valE;
    wire [3:0] e_dstE;    
    wire [3:0] W_icode;
    wire [3:0] W_dstE;
    wire [3:0] W_dstM;
    wire [63:0] W_valE;
    wire [63:0] W_valM;    
    wire [3:0] W_stat;
    wire [3:0] srcA;
    wire [3:0] srcB;
    wire [63:0] m_valM;
    wire [3:0] m_stat;
    wire e_Cnd;
    wire setcc;
    wire [2:0]cc_in;
    wire [63:0] PC;

fetchc DUT(clk,F_predPC,M_icode,W_icode,M_valA,W_valM,M_Cnd,F_stall,D_stall,D_bubble,f_predPC,
D_ifun,D_icode,D_rA,D_rB,D_valC,D_valP,D_stat,PC);

decodec decode_(clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE, 
valE, m_valM, M_valE, W_valM, W_valE, E_bubble, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, E_srcA, 
E_srcB, E_stat,srcA,srcB);

// executec exe(clk,E_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_dstE,
// E_dstM,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_dstE,M_dstM,valE,e_dstE,e_Cnd);

executec exe(clk,E_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_dstE,E_dstM,setcc,valE,e_dstE,e_Cnd,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_dstE,M_dstM,cc_in);

memory mem(clk, M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, 
W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat);

writeback writ(clk,W_icode,W_dstE,W_dstM,W_valE,W_valM);

pipe_control pipe(D_icode,srcA,srcB,E_icode,E_dstM,e_Cnd,M_icode,m_stat,W_stat,setcc,F_stall,D_stall,D_bubble,E_bubble);
    
// control control(D_icode,srcA,srcB,E_icode,E_dstM,e_Cnd,M_icode,m_stat,W_stat,
//                 setcc,F_stall,D_stall,D_bubble,E_bubble,W_stall);
    always @(W_icode) 
    begin
        if(W_icode==0) 
        $finish;
    end

  always @(posedge clk) F_predPC <= f_predPC;

  always repeat(1000) #10 clk = ~clk;

  initial
  begin

    $dumpfile("memory_tb.vcd");
    $dumpvars(0, memory_tb);

    F_predPC = 64'd0;
    clk = 0;
    // F_stall = 0;
    // D_stall = 0;
    // D_bubble = 0;
    // E_bubble = 0;


  end

  initial 
  begin
    $monitor($time, "\tclk=%d\n\t\t\tF Reg:\t\tF_predPC = %d\n\t\t\tfetch:\t\tf_predPC = %d\n\t\t\tD Reg:\t\tD_icode = %b D_ifun = %b D_rA = %b D_rB = %b D_valC = %d D_valP = %d D_stat = %d\n\t\t\tdecode:\t\t\n\t\t\tE Reg:\t\tE_icode = %b E_ifun = %b E_valA = %d E_valB = %d E_valC = %d E_dstE = %b E_dstM = %b E_srcA = %d E_srcB = %d E_stat = %d\n\t\t\texecute:\t M_valE = %d\n\t\t\tM Reg:\t\tM_icode = %b M_cnd = %b M_valA = %d M_valE = %d M_dstE = %b, M_dstM = %b M_stat = %d\n\t\t\tmemory:\t\tm_valM = %d\n\t\t\tW Reg:\t\tW_icode = %b W_valE = %d W_valM = %d W_dstE = %b W_dstM = %b W_stat = %d\n",clk,F_predPC,f_predPC,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_dstE,E_dstM,E_srcA,E_srcB,E_stat,M_valE,M_icode,M_Cnd,M_valA,M_valE,M_dstE,M_dstM,M_stat,m_valM,W_icode,W_valE,W_valM,W_dstE,W_dstM,W_stat);

  end

endmodule