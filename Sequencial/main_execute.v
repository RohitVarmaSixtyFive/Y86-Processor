`include "alu.v"
module main_execute(icode,ifun,valA,valB,valC,rB_in,rB_out,valE,clk,cnd,cc_out,cc_in);

  input clk;
  input [3:0] icode,ifun; 
  input [3:0] rB_in;
  input [63:0] valA,valB,valC; 
  input [2:0] cc_in;
  output reg [63:0] valE;
  output reg cnd;
  output reg [2:0] cc_out;
  output reg [3:0] rB_out;

  reg [1:0] Select_Line;
  reg signed [63:0] alu_a,alu_b,Op;
  wire signed [63:0] out;
  wire carry;

  alu alu(alu_a,alu_b,Select_Line,out,carry);

initial begin
    alu_a = 64'd0;
    alu_b = 64'd0;
    Select_Line = 64'd0;
    cnd = 1'd0;
end

  reg zf,sf,of;

  always @(*)begin
  if (icode == 4'b0010) begin //cmovX
        cnd = 1'b0;
        zf = cc_in[0];
        sf = cc_in[1];
        of = cc_in[2];
        case(ifun)
        4'h0: begin //unconditional 
            cnd = 1'd0;
        end
        4'h1: begin //le
            cnd = (of ^ sf) | zf; 
        end
        4'h2: begin //l
            cnd = (of ^ sf); 
        end
        4'h3: begin //e
            cnd = zf; 
        end
        4'h4: begin //ne
            cnd = ~zf;  
        end
        4'h5: begin //ge
            cnd = ~(of ^ sf); 
        end
        4'h6: begin //g
            cnd = ~(of ^ sf) & ~zf;
        end
        default: begin // Default case
            cnd = 0;
        end
    endcase

    if (cnd == 1) begin 
        rB_out[0] = 4'b1;
        rB_out[1] = 4'b1;
        rB_out[2] = 4'b1;
        rB_out[3] = 4'b1;            
    end
    else begin
        rB_out[0] = rB_in[0];
        rB_out[1] = rB_in[1];
        rB_out[2] = rB_in[2];
        rB_out[3] = rB_in[3];
    end
        valE <= valA;
      end
  end

  always @(*)begin

    if(icode == 4'b0111) begin //jmp
        cnd = 1'd0;
        zf = cc_in[0];
        sf = cc_in[1];
        of = cc_in[2];

        case (ifun)
        4'h0: cnd = 1'd1; // unconditional
        4'h1: cnd = (of ^ sf) | zf; // le
        4'h2: cnd = (of ^ sf); // l
        4'h3: cnd = zf; // e
        4'h4: cnd = ~zf; // ne
        4'h5: cnd = ~(of ^ sf); // ge
        4'h6: cnd = ~(of ^ sf) & ~zf; // g
        default: cnd = 0; // default case
endcase

      end
  end

  always @(*) begin

      case (icode)
        4'b0011: begin //irmovq
            valE <= valC;
        end
        4'b0100, 4'b0101: begin //rmmovq, mrmovq
            Select_Line = 2'b00;
            alu_a = valB;
            alu_b = valC;
            valE <= out;
        end
        4'b0110: begin //OPq - Addition, Subtraction, AND, XOR
            cc_out[2] = carry;
            cc_out[1] = valE[63];
            cc_out[0] = (valE == 64'd0) ? 1'b1 : 1'b0;

            case (ifun)
                4'b0000: begin //ADD
                    Select_Line = 2'b00;
                    alu_a = valA;
                    alu_b = valB;
                end
                4'b0001: begin //SUBTRACT
                    Select_Line = 2'b01;
                    alu_a = valB;
                    alu_b = valA;
                end
                4'b0010: begin //AND
                    Select_Line = 2'b10;
                    alu_a = valA;
                    alu_b = valB;
                end
                4'b0011: begin //XOR
                    Select_Line = 2'b11;
                    alu_a = valA;
                    alu_b = valB;
                end
                default: begin // Default case
                    // Handle unexpected ifun
                end
            endcase
            valE <= out;
        end
        4'b1000: begin //Call
            Select_Line = 2'b01;
            alu_a = valB;
            alu_b = 64'd8;
            valE <= out;
        end
        4'b1001, 4'b1010, 4'b1011: begin //Ret, pushq, popq
            if (icode == 4'b1001) begin //Ret
                Select_Line = 2'b00;
            end
            else begin // pushq, popq
                Select_Line = 2'b00;
            end
            alu_a = valB;
            alu_b = (icode == 4'b1010) ? -64'd8 : 64'd8; // Adjust alu_b based on icode
            valE <= out;
        end
        // default: begin // Default case
        // end
    endcase
    end 
endmodule
