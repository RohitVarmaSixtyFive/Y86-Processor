module writeback(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    input cnd,
    input [63:0] valE,
    input [63:0] valM,
    input [63:0] valA
);

    reg [3:0] dstE;
    reg [3:0] dstM;

    reg [63:0] reg_file[0:14];

    // Initialization
    initial begin
        dstE = 4'd15;
        dstM = 4'd15;
        $readmemh("reg_file.txt", reg_file);
    end

    always @(posedge clk) begin
        $writememh("reg_file.txt", reg_file);
    end

    always @* begin
        case (icode)
            4'd2: begin//forgot cmov check once ig
            if (cnd == 1)
            begin
                dstE = rB;
                reg_file[dstE] = valE;
            end
            end
            4'd3: begin
                dstE = rB;
                reg_file[dstE] = valE;
            end
            4'd5: begin
                dstM = rA;
                reg_file[dstM] = valM;
            end
            4'd6: begin
                dstE = rB;
                reg_file[dstE] = valE;
            end
            4'd8: begin
                dstE = 4'd4;
                reg_file[dstE] = valA;
            end
            4'd9: begin
                dstE = 4'd4;
                reg_file[dstE] = valE;
            end
            4'd10: begin
                dstE = 4'd4;
                reg_file[dstE] = valE;
            end
            4'd11: begin
                dstE = 4'd4;
                reg_file[dstE] = valE;
                dstM = rA;
                reg_file[dstM] = valM;
            end
        endcase
    end

endmodule