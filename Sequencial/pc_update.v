module pc_update (
    input clk,
    input cnd,
    input [3:0] icode,
    input [63:0] valC,
    input [63:0] valM,
    input [63:0] valP,
    input [63:0] PC,
    output reg [63:0] updated_pc
);

    always @* begin
        case (icode)
            4'd7: begin
                if (cnd == 1'b1)
                    updated_pc = valC;
                else
                    updated_pc = valP;
            end
            4'd8: begin
                updated_pc = valC;
            end
            4'd9: begin
                updated_pc = valM;
            end
            default: begin
                updated_pc = valP;
            end
        endcase
    end

endmodule
