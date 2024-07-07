module memory(clk, M_stat, M_icode, M_cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat);

    input clk;
    input [3:0] M_stat;
    input [3:0] M_icode;
    input M_cnd;
    input [63:0] M_valE, M_valA;
    input [3:0] M_dstE, M_dstM;

    output reg [3:0] W_stat;
    output reg [3:0] W_icode;
    output reg [63:0] W_valE, W_valM;
    output reg [3:0] W_dstE, W_dstM;
    output reg [63:0] m_valM;
    output reg [3:0] m_stat;

    reg [63:0] data_memory [1023:0];
    reg [63:0] memory_address;
    reg dmem_error = 0;


    initial begin
        $readmemh("data_memory.txt", data_memory);
        m_valM = 64'd0;
        dmem_error = 1'b0;
        memory_address = 64'd0;
    end
    
    always @(*) begin
        $writememh("data_memory.txt", data_memory);
    end

    always @(*) begin
        case (M_icode)
            4'd4: begin
                memory_address = M_valE;
                data_memory[M_valE] = M_valA;
            end
            4'd5: begin
                memory_address = M_valE;
                m_valM = data_memory[M_valE];
            end
            4'd8: begin
                memory_address = M_valE;
                data_memory[M_valE] = M_valA;
            end
            4'd9: begin
                memory_address = M_valA;
                m_valM = data_memory[M_valA];
            end
            4'd10: begin
                memory_address = M_valE;
                data_memory[M_valE] = M_valA;
            end
            4'd11: begin
                memory_address = M_valA;
                m_valM = data_memory[M_valA];
            end
            // default: begin
            //     // No memory operation for other instructions
            //     memory_address = 64'd0;
            // end
        endcase
        // datamem = data_memory[M_valE];
    end

    // Error handling for out-of-bounds memory address
    always @(*) begin
        if (memory_address > 1023) begin
            dmem_error = 1'b1;
        end else begin
            dmem_error = 1'b0;
        end
    end

        always@(*)
    begin
        if(dmem_error==1)
            m_stat = 2'd2;
        else 
            m_stat = M_stat;
    end

    always@(posedge clk)
    // always@(*)
    begin
        W_stat <= m_stat;
        W_icode <= M_icode;
        W_valE <= M_valE;
        W_valM <= m_valM;
        W_dstE <= M_dstE;
        W_dstM <=M_dstM;
    end

endmodule

