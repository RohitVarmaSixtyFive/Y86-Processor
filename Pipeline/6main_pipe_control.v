module pipe_control(
    input [3:0] D_icode,
    input [3:0] d_srcA,
    input [3:0] d_srcB,
    input [3:0] E_icode,
    input [3:0] E_destM,
    input e_Cnd,
    input [3:0] M_icode,
    input [0:3] m_stat,
    input [0:3] W_stat,

    output reg setcc,
    output reg F_stall,
    output reg D_stall,
    output reg D_bubble,
    output reg E_bubble
);

always @(*) begin
    setcc = 1'b1;
    F_stall = 1'b0;
    D_stall = 1'b0; 
    D_bubble = 1'b0;
    E_bubble = 1'b0;

    if (((E_icode == 4'h5 || E_icode == 4'hB) && (((E_destM == d_srcA) && (E_destM != 4'hF)) || ((E_destM == d_srcB) && (E_destM != 4'hF)))) || (D_icode == 4'h9 || E_icode == 4'h9 || M_icode == 4'h9)) begin
        F_stall = 1'b1;
    end

    if ((E_icode == 4'h5 || E_icode == 4'hB) && (((E_destM == d_srcA) && (E_destM != 4'hF)) || ((E_destM == d_srcB) && (E_destM != 4'hF)))) begin
        D_stall = 1'b1;
    end

    if ((E_icode == 4'h7 && !e_Cnd) || (!((E_icode == 4'h5 || E_icode == 4'hB) && (((E_destM == d_srcA) && (E_destM != 4'hF)) || ((E_destM == d_srcB) && (E_destM != 4'hF)))) && (D_icode == 4'h9 || E_icode == 4'h9 || M_icode == 4'h9))) begin
        D_bubble = 1'b1;
    end

    if ((E_icode == 4'h7 && !e_Cnd) || ((E_icode == 4'h5 || E_icode == 4'hB) && (((E_destM == d_srcA) && (E_destM != 4'hF)) || ((E_destM == d_srcB) && (E_destM != 4'hF))))) begin
        E_bubble = 1'b1;
    end

    if ((E_icode == 4'h0) | (m_stat != 4'b1000) | (W_stat != 4'b1000)) begin
        setcc = 1'b0;
    end
end

endmodule
