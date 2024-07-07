module decodec(clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, 
    D_stat, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE, e_valE, m_valM, M_valE,
    W_valM, W_valE, E_bubble, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, 
    E_dstM, E_srcA, E_srcB, E_stat,srcA,srcB);

    input clk;
    
    input [3:0] D_icode;
    input [3:0] D_ifun;

    input [3:0] D_rA;
    input [3:0] D_rB;  

    input [63:0] D_valC;
    input [63:0] D_valP;

    input [3:0] D_stat;  

    input [3:0] e_dstE, M_dstM, M_dstE, W_dstM, W_dstE;
    input [63:0] e_valE, m_valM, M_valE, W_valM, W_valE;

    input E_bubble;

    output reg [3:0] E_icode;
    output reg [3:0] E_ifun;

    output reg [63:0] E_valA;
    output reg [63:0] E_valB;
    output reg [63:0] E_valC;

    output reg [3:0] E_dstE;
    output reg [3:0] E_dstM;
    output reg [3:0] E_srcA;
    output reg [3:0] E_srcB;

    output reg [3:0] E_stat; 

     reg [63:0] valA;
     reg [63:0] valB;
    output reg [3:0] srcA, srcB;
    reg [3:0] dstE, dstM;

    reg [63:0] Reg_File[0:14];


    always@(posedge clk)
    begin

        $readmemh("reg_file.txt", Reg_File);
        
    end

    always @(*)
begin
    case (D_icode)
        4'd2: begin
            srcA = D_rA;
            srcB = 4'hf;
            dstE = D_rB;
            dstM = 4'hf;
            valA = Reg_File[D_rA];
        end
        4'd3: begin
            dstE = D_rB;
            dstM = 4'hf;
            srcA = 4'hf;
            srcB = 4'hf;
        end
        4'd4: begin
            srcA = D_rA;
            srcB = D_rB;
            dstE = 4'hf;
            dstM = 4'hf;
            // valA  R[rA]
            valA = Reg_File[D_rA];
            // valB  R[rB]
            valB = Reg_File[D_rB];
        end
        4'd5: begin
            srcA = 4'hf;
            srcB = D_rB;
            dstM = D_rA; 
            dstE = 4'hf;               
            // valB  R[rB]
            valB = Reg_File[D_rB];
        end
        4'd6: begin
            srcA = D_rA;
            srcB = D_rB;
            dstE = D_rB;
            dstM = 4'hf;               
            // valA  R[rA]
            valA = Reg_File[D_rA];
            // valB  R[rB]
            valB = Reg_File[D_rB];    
        end
        4'd8: begin
            srcA = 4'hf;
            srcB = 4'd4;
            dstE = 4'd4;
            dstM = 4'hf;               
            //valB  R[ %rsp ]
            valB = Reg_File[4'd4];    
        end
        4'd9: begin
            srcA = 4'd4;
            srcB = 4'd4;
            dstE = 4'd4;
            dstM = 4'hf;               
            // valA  R[ %rsp ]
            valA = Reg_File[4'd4];
            // valB  R[ %rsp ]
            valB = Reg_File[4'd4];
        end
        4'd10: begin
            srcA = D_rA;
            srcB = 4'd4;
            dstE = 4'd4;
            dstM = 4'hf;               
            // valA  R[rA]
            valA = Reg_File[D_rA];
            // valB  R[ %rsp ]
            valB = Reg_File[4'd4];
        end
        4'd11: begin
            srcA = 4'd4;
            srcB = 4'd4;
            dstE = 4'd4;
            dstM = D_rA;
            // valA  R[ %rsp ]
            valA = Reg_File[4'd4];
            // valB  R[ %rsp ]
            valB = Reg_File[4'd4];   
        end
        default: begin
            srcA = 4'hf;
            srcB = 4'hf;
            dstE = 4'hf;
            dstM = 4'hf;
        end
    endcase
end


    always@(*)
    begin

        //Forwarding logic for valA
            if(D_icode == 4'd8 || D_icode == 4'd7)
            begin
                valA = D_valP;
            end
            else if (srcA == e_dstE && srcA != 4'hf)
            begin
                valA = e_valE;
            end
            else if (srcA == M_dstM && srcA != 4'hf)
            begin
                valA = m_valM;
            end
            else if (srcA == M_dstE && srcA != 4'hf)
            begin
                valA = M_valE;
            end
            else if (srcA == W_dstM && srcA != 4'hf)
            begin
                valA = W_valM;
            end
            else if (srcA == W_dstE && srcA != 4'hf)
            begin
                valA = W_valE;
            end
    end
        
    always@(*)
    begin
            //Forwarding logic for valB
            if(srcB == e_dstE && srcB != 4'hf)
            begin
                valB = e_valE;
            end
            else if(srcB == M_dstM && srcB != 4'hf)
            begin
                valB = m_valM;
            end
            else if(srcB == M_dstE && srcB != 4'hf)
            begin
                valB = M_valE;
            end
            else if(srcB == W_dstM && srcB != 4'hf)
            begin
                valB = W_valM;
            end
            else if(srcB == W_dstE && srcB != 4'hf)
            begin
                valB = W_valE;
            end

    end

    always@(posedge clk)
    begin

        if(E_bubble == 1)
        begin
            E_icode <= 4'b0001; //nop
            E_ifun <= 4'b0000;
            E_valA <= 4'b0000;
            E_valB <= 4'b0000;
            E_valC <= 4'b0000;
            E_srcA <= 4'hf;
            E_srcB <= 4'hf;
            E_dstE <= 4'hf;
            E_dstM <= 4'hf;
            E_stat <= 2'd0;
        end
        else
        begin
            E_icode <= D_icode; 
            E_ifun <= D_ifun;
            E_valA <= valA;
            E_valB <= valB;
            E_valC <= D_valC;
            E_srcA <= srcA;
            E_srcB <= srcB;
            E_dstE <= dstE;
            E_dstM <= dstM;
            E_stat <= D_stat;
        end
    end

endmodule