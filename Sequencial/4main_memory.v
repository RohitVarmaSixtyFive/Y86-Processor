module memory(
    input clk,
    input [3:0] icode,
    input [63:0] valA,
    input [63:0] valE,
    input [63:0] valP,  
    output reg [63:0] valM,
    output reg dmem_error,
    output reg [63:0] datamem,// are these both really required
    output reg [63:0] memory_address
);

    // Data Memory
    reg [63:0] data_memory [0:1000];

    initial begin
        valM = 64'd0;
        dmem_error = 1'b0;
        memory_address = 64'd0;
        $readmemh("data_memory.txt", data_memory);
    end

    always @(posedge clk) begin
        $writememh("data_memory.txt", data_memory);
    end

    always @* begin
        case (icode)
            4'd4: begin
                memory_address = valE;
                data_memory[valE] = valA;
            end
            4'd5: begin
                memory_address = valE;
                valM = data_memory[valE];
            end
            4'd8: begin
                memory_address = valE;
                data_memory[valE] = valP;
            end
            4'd9: begin
                memory_address = valA;
                valM = data_memory[valA];
            end
            4'd10: begin
                memory_address = valE;
                data_memory[valE] = valA;
            end
            4'd11: begin
                memory_address = valA;
                valM = data_memory[valA];
            end
            default: begin
                // No memory operation for other instructions
                memory_address = 64'd0;
            end
        endcase
        datamem = data_memory[valE];
    end

    // Error handling for out-of-bounds memory address
    always @(posedge clk) begin
        if (memory_address > 1023) begin
            dmem_error = 1'b1;
        end else begin
            dmem_error = 1'b0;
        end
    end

endmodule
