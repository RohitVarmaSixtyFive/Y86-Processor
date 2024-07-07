
module memory(
    input clk,
    input [3:0] icode,
    input [63:0] valA,
    input [63:0] valE,
    input [63:0] valP,
    output reg [63:0] valM,
    output reg dmem_error,
    output reg [63:0] datamem,
    output reg [63:0] memory_address
);

    // Data Memory
    reg [63:0] data_memory [9:0];

    // Instruction codes
    // parameter IHALT   = 4'd0;
    // parameter INOP    = 4'd1;
    // parameter IRRMOVQ = 4'd2; // rrmovq and cmovXX
    // parameter IIRMOVQ = 4'd3;
    // parameter IRMMOVQ = 4'd4;
    // parameter IMRMOVQ = 4'd5;
    // parameter IOPQ    = 4'd6;
    // parameter IJXX    = 4'd7;
    // parameter ICALL   = 4'd8;
    // parameter IRET    = 4'd9;
    // parameter IPUSHQ  = 4'd10;
    // parameter IPOPQ   = 4'd11;

    // Initialization
    initial begin
        valM = 64'd0;
        dmem_error = 1'b0;
        memory_address = 64'd0;
        $readmemh("data_memory.txt", data_memory);
    end

    // Write to data_memory.txt on every clock edge
    always @(posedge clk) begin
        $writememh("data_memory.txt", data_memory);
    end

    // Memory operations based on instruction code
    always @* begin
        case (icode)
            4'd3: begin
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
