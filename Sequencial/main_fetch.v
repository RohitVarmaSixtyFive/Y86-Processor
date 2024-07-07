module main_fetch(clk, PC, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid, hlt);

    input clk;
    input [63:0] PC;
    
    output reg [3:0] icode;
    output reg [3:0] ifun;

    output reg [3:0] rA;
    output reg [3:0] rB;

    output reg [63:0] valC;
    output reg [63:0] valP;

    output reg instr_valid; 
    output reg imem_error;
    output reg hlt;

    reg [0:79] instruction; //Instruction encodings range between 1 and 10 bytes
    reg [7:0] memory[0:66]; //size of the array changes based on the size of the total instruction memory
    reg [0:7] rArB_Extract; //part of instruction code
    reg [0:71] jump_handle;

    initial
    begin
        rA = 4'h0;
        rB = 4'h0;
        valC = 64'd0;
        hlt = 0;
        instr_valid = 0;
        imem_error = 0;
    end

    initial begin
        $readmemb("1.txt", memory);
        #10;
    end

    always@(posedge clk)
    begin

        if(PC > 64'd1023)
        begin

            imem_error = 1; //invalid address        
        end
        else
        begin

            imem_error = 0;

            //Instruction encodings range between 1 and 10 bytes
            instruction = {memory[PC], memory[PC+64'd1], memory[PC+64'd9], memory[PC+64'd8], memory[PC+64'd7], memory[PC+64'd6], memory[PC+64'd5], memory[PC+64'd4], memory[PC+64'd3], memory[PC+64'd2]}; 
    
            //An instruction consists of a 1-byte instruction specifier, 1-byte register specifier, and an 8-byte constant word.

            icode = instruction[0:3];
            ifun = instruction[4:7];

            if(icode == 4'd7 | icode == 4'd8)
            begin
                jump_handle = {memory[PC],memory[PC+8],memory[PC+7],memory[PC+6],memory[PC+5],memory[PC+4],memory[PC+3],memory[PC+2],memory[PC+1]};
                icode = jump_handle[0:3];
                ifun = jump_handle[4:7];
            end


            if(icode < 4'd0 || icode > 4'd11)
            begin

                instr_valid = 1; //invalid instruction
            end
            else
            begin

                instr_valid = 0;
                
    case (icode)
        // Halt
        4'd0: begin
            hlt = 1;
            valP = PC + 64'd1;
        end
        // NOP
        4'd1: begin
            valP = PC + 64'd1;
        end
        // rrmovq and cmovXX
        4'd2: begin
            rArB_Extract = memory[PC+64'd1];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
        end
        // irmovq
        4'd3: begin
            rArB_Extract = memory[PC+64'd1];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];  
            valP = PC + 64'd10;
        end
        // rmmovq
        4'd4: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
        end
        // mrmovq
        4'd5: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
        end
        // Opq
        4'd6: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
        end
        // jXX
        4'd7: begin
            valC = jump_handle[8:71];
            valP = PC + 64'd9;
        end
        // call
        4'd8: begin
            valC = jump_handle[8:71];
            valP = PC + 64'd9;
        end
        // ret
        4'd9: begin
            valP = PC + 64'd1;
        end
        // pushq
        4'd10: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
        end
        // popq
        4'd11: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
        end
        default: begin
            instr_valid = 1; // invalid instruction
        end
    endcase
        end
    end
end    
endmodule
