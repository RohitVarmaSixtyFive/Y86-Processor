`include "alu.v"

module executec(clk,E_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_destE,E_destM,setcc,e_valE,e_destE,e_Cnd,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_destE,M_destM,cc_in);

  input clk;
  input [0:3] E_stat;
  input [3:0] E_icode,E_ifun,E_destE,E_destM;
  input signed [63:0] E_valA,E_valB,E_valC;
  input setcc;

  output reg signed [63:0] e_valE,M_valE,M_valA;
  output reg [3:0] e_destE,M_destE,M_destM,M_icode;
  output reg e_Cnd;
  output reg [0:3] M_stat;
  output reg M_Cnd;

  output reg [2:0] cc_in = 3'b000;
  // reg [2:0] cc_out;
  reg [1:0] select_line;
  reg signed [63:0] Input1,Input2;
  wire signed [63:0] Output;
  wire carry;

  alu alu(Input1,Input2,select_line,Output,carry);
  
always @(*) begin
    case(E_icode)
        4'b0010: begin // cmovXX-rrmovq, cmovle, cmovl, cmove, cmovne, cmovge, cmovg
            e_valE <= E_valA;
        end
        4'b0011: begin // irmovq
            e_valE <= E_valC;
        end
        4'b0100: begin // rmmovq
            select_line = 2'b00;
            Input1 = E_valB;
            Input2 = E_valC;
            e_valE <= Output;
        end
        4'b0101: begin // mrmovq
            select_line = 2'b00;
            Input1 = E_valB;
            Input2 = E_valC;
            e_valE <= Output;
        end
        4'b0110: begin // OPq - Addition, Subtraction, AND, XOR
            case(E_ifun)
                4'b0000: begin // ADD
                    select_line = 2'b00;
                    Input1 = E_valA;
                    Input2 = E_valB;
                end
                4'b0001: begin // SUBTRACT
                    select_line = 2'b01;
                    Input1 = E_valA;
                    Input2 = E_valB;
                end
                4'b0010: begin // AND
                    select_line = 2'b10;
                    Input1 = E_valA;
                    Input2 = E_valB;
                end
                4'b0011: begin // XOR
                    select_line = 2'b11;
                    Input1 = E_valA;
                    Input2 = E_valB;
                end
                default: begin
                    // Default case for E_ifun
                    select_line = 2'b00;
                    Input1 = 0;
                    Input2 = 0;
                end
            endcase
            
            e_valE <= Output;
            
            if (setcc) begin
                cc_in[2] <= carry;
                cc_in[1] <= e_valE[63];
                cc_in[0] <= (e_valE == 64'd0) ? 1'b1 : 1'b0;
            end
        end
        4'b1000: begin // Call
            select_line = 2'b01;
            Input1 = E_valB;
            Input2 = 64'd1;
            e_valE <= Output;
        end
        4'b1001: begin // Ret
            select_line = 2'b00;
            Input1 = E_valB;
            Input2 = 64'd1;
            e_valE <= Output;
        end
        4'b1010: begin // pushq
            select_line = 2'b01;
            Input1 = E_valB;
            Input2 = 64'd1;
            e_valE <= Output;
        end
        4'b1011: begin // popq
            select_line = 2'b00;
            Input1 = E_valB;
            Input2 = 64'd1;
            e_valE <= Output;
        end
        default: begin
            // Default case for E_icode
            e_valE <= 0;
        end
    endcase
end

  wire zf,sf,of;
  assign zf = cc_in[0];
  assign sf = cc_in[1];
  assign of = cc_in[2];

  always @(*)
  begin
      if(E_icode == 4'b0010 || E_icode == 4'b0111) //cmovXX && jgXX
      begin
          if(E_ifun == 4'h0)begin //unconditional 
              e_Cnd = 1;
          end
          else if(E_ifun== 4'h1)begin //le
              e_Cnd = (of^sf)|zf; 
          end
          else if(E_ifun == 4'h2)begin //l
              e_Cnd = (of^sf); 
          end
          else if(E_ifun == 4'h3)begin //e
              e_Cnd = zf;             
          end
          else if(E_ifun == 4'h4)begin //ne
              e_Cnd = ~zf;  
          end
          else if(E_ifun == 4'h5)begin //ge
              e_Cnd = ~(of^sf); 
          end
          else if(E_ifun == 4'h6)begin //g
              e_Cnd = ~(of^sf) & ~(zf);
          end
        e_destE = (e_Cnd == 1) ? E_destE : 4'b1111;    //empty register
      end
      else
      begin
        e_destE =E_destE;
        e_Cnd=0;
      end
  end

  always@(posedge clk)
  begin
      M_stat <= E_stat;
      M_icode <= E_icode;
      M_Cnd <= e_Cnd;
      M_valE <= e_valE;
      M_valA <= E_valA;
      M_destE <= e_destE;
      M_destM <= E_destM;
  end
endmodule