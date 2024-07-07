module writeback(
    input clk,
    input [3:0] W_icode,

    input [3:0] W_dstE,
    input [3:0] W_dstM,

    input [63:0] W_valE,
    input [63:0] W_valM
);



    reg [63:0] reg_file[0:14];

    // Initialization
    initial begin
        // W_dstE = 4'd15;
        // W_dstM = 4'd15;
        $readmemh("reg_file.txt", reg_file);
    end

    always @(posedge clk) begin
        $writememh("reg_file.txt", reg_file);
    end

    always @* begin
        case (W_icode)
            4'd2: begin
                reg_file[W_dstE] = W_valE;
            end
            4'd3: begin
                reg_file[W_dstE] = W_valE;
            end
            4'd5: begin
                reg_file[W_dstM] = W_valM;
            end
            4'd6: begin
             
                reg_file[W_dstE] = W_valE;
            end
            4'd8: begin
           
                reg_file[W_dstE] = W_valE;
            end
            4'd9: begin
             
                reg_file[W_dstE] = W_valE;
            end
            4'd10: begin

                reg_file[W_dstE] = W_valE;
            end
            4'd11: begin
                reg_file[W_dstE] = W_valE;
                reg_file[W_dstM] = W_valM;
            end
        endcase
    end

endmodule