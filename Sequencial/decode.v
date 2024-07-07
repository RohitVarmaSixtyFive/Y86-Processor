// DECODE BLOCK

module decode(clk, icode, rA, rB, valA, valB);

    input clk;
    input [3:0] icode;
    input [3:0] rA;
    input [3:0] rB;

    output reg [63:0] valA;
    output reg [63:0] valB;

    reg [63:0] Reg_File[0:14];

    integer i;

    initial
    begin
        valA = 64'd0;
        valB = 64'd0;
    end

   always@(posedge clk)
    begin

        $readmemh("reg_file.txt", Reg_File);
        
    end

    always@(*)
    begin

        if(clk == 1)

            case (icode)
        // Halt
        4'd0: begin
            // valA ← R[rA]
            valA = Reg_File[rA];    
        end
        // NOP
        4'd1: begin
            // valA ← R[rA]
            valA = Reg_File[rA];
                
            // valB ← R[rB]
            valB = Reg_File[rB];
        end
        // rrmovq and cmovXX
        4'd2: begin
            valA = Reg_File[rA];

        end

        // rmmovq
        4'd4: begin
            // valA ← R[rA]
            valA = Reg_File[rA];
                
            // valB ← R[rB]
            valB = Reg_File[rB];
        end
        // mrmovq
        4'd5: begin
            // valB ← R[rB]
            valB = Reg_File[rB];
        end
        // Opq
        4'd6: begin
            // valA ← R[rA]
            valA = Reg_File[rA];
                
            // valB ← R[rB]
            valB = Reg_File[rB];
        end
        // jXX

        // call
        4'd8: begin
            // valB ← R[rsp]
            valB = Reg_File[4];
        end
        // ret
        4'd9: begin
            // valA ← R[rsp]
            valA = Reg_File[4];
                
            // valB ← R[rsp]
            valB = Reg_File[4];
        end
        // pushq
        4'd10: begin
            // valA ← R[ra]
            valA = Reg_File[rA];
                
            // valB ← R[rsp]
            valB = Reg_File[4];
        end
        // popq
        4'd11: begin
            // valA ← R[rsp]
            valA = Reg_File[4];
                
            // valB ← R[rsp]
            valB = Reg_File[4];
        end
        // default: begin
        //     instr_valid = 1; // invalid instruction
        // end
    endcase
end

endmodule
