`include "xora.v"
`include "adder.v"
`include "aluand.v"
`include "sub.v"
`include "full_adder.v"

module alu(i_a, i_b, select, out, o_carry);
    input signed [63:0] i_a, i_b;
    input [1:0] select;
    output reg signed [63:0] out;
    output reg signed o_carry;
    wire signed [63:0] o_add, o_sub, o_and, o_xor;
    // wire carry1, carry2;

    adder ADD(i_a, i_b, o_add, carry1);
    sub SUB(i_a, i_b, o_sub, carry2);
    aluand AND(o_and, i_a, i_b);
    xora XOR(o_xor, i_a, i_b);

    always @* begin
        case (select)
            2'b00: begin
                out <= o_add;
                if ((i_a < 0 == i_b < 0) && (o_add < 0 != i_a < 0))
                    o_carry <= 1;
                else
                    o_carry <= 0;
            end
            2'b01: begin
                out <= o_sub;
                if ((i_a < 0 == i_b > 0) && (o_sub <0 != i_a <0))
                    o_carry <= 1;
                else
                    o_carry <= 0;
            end
            2'b10: begin
                out <= o_and;
                o_carry <= 0; 
            end
            2'b11: begin
                out <= o_xor;
                o_carry <= 0; 
            end
        endcase
    end

endmodule
