module control (
    input [3:0] D_icode, d_srcA, d_srcB,
    input [3:0] E_icode, E_dstM,
    input e_cnd,
    input [3:0] M_icode,
    input [0:3] m_stat,
    input [0:3] W_stat,

    output reg set_cc, F_stall, D_stall, D_bubble, E_bubble, W_stall
);

always @(*)
begin
    F_stall = 0;
    D_stall = 0;
    D_bubble = 0;
    E_bubble = 0;
    W_stall = 0;
    set_cc = 1;

    if (D_icode==4'b1001 || E_icode==4'b1001 || M_icode==4'b1001) // stall/bubble condition for ret
    begin
       F_stall = 1'b1;
       D_bubble = 1'b1; 
    end
    else if (E_icode==4'b0111 && !e_cnd) // stall/bubble condition for Jump misprediction
    begin
        D_bubble = 1'b1;
        E_bubble = 1'b1;
    end
    else if((E_icode == 4'b0101 || E_icode == 4'b1011) && (E_dstM==d_srcA || E_dstM==d_srcB)) // stall/bubble condition for load-use hazard
    begin
        F_stall = 1'b1;
        D_stall = 1'b1;
        E_bubble = 1'b1;
    end
    else if(E_icode == 4'b0000 || m_stat!=4'b1000 || W_stat!=4'b1000)
    begin
        set_cc = 1'b0;
    end
end
endmodule