// FETCH BLOCK

module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid, hlt);

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
    reg [7:0] memory[0:1023]; //memory has 256-32 bits words => 1024-8 bits

    reg [0:7] opcode; //operation codes
    reg [0:7] regids; //register IDs

    initial
    begin
        rA = 4'h0;
        rB = 4'h0;
        valC = 64'd0;
        valP = 64'd0;
        hlt = 0;
        instr_valid = 0;
        imem_error = 0;
    end

    // instruction codes
    // Constant values used in HCL descriptions.
    // parameter IHALT   = 4'd0;
    // parameter INOP    = 4'd1;
    // parameter IRRMOVQ = 4'd2; //rrmovq and  cmovXX
    // parameter IIRMOVQ = 4'd3;
    // parameter IRMMOVQ = 4'd4;
    // parameter IMRMOVQ = 4'd5;
    // parameter IOPQ    = 4'd6;
    // parameter IJXX    = 4'd7;
    // parameter ICALL   = 4'd8;
    // parameter IRET    = 4'd9;
    // parameter IPUSHQ  = 4'd10;
    // parameter IPOPQ   = 4'd11;

    initial 
    begin

    // irmovq $0x0, %rax
    memory[0]=8'b00110000; //3 0
    memory[1]=8'b00000000; //F rB=0
    memory[2]=8'b00000000;           
    memory[3]=8'b00000000;           
    memory[4]=8'b00000000;           
    memory[5]=8'b00000000;           
    memory[6]=8'b00000000;           
    memory[7]=8'b00000000;           
    memory[8]=8'b00000000;          
    memory[9]=8'b00000000; //V=0

    // irmovq $0x10, %rdx
    memory[10]=8'b00110000; //3 0
    memory[11]=8'b00000010; //F rB=2
    memory[12]=8'b00000000;           
    memory[13]=8'b00000000;           
    memory[14]=8'b00000000;           
    memory[15]=8'b00000000;           
    memory[16]=8'b00000000;           
    memory[17]=8'b00000000;           
    memory[18]=8'b00000000;          
    memory[19]=8'b00010000; //V=16

    // irmovq $0xc, %rbx
    memory[20]=8'b00110000; //3 0
    memory[21]=8'b00000011; //F rB=3
    memory[22]=8'b00000000;           
    memory[23]=8'b00000000;           
    memory[24]=8'b00000000;           
    memory[25]=8'b00000000;           
    memory[26]=8'b00000000;           
    memory[27]=8'b00000000;           
    memory[28]=8'b00000000;          
    memory[29]=8'b00001100; //V=12

    // jmp check
    memory[30]=8'b01110000; //7 fn
    memory[31]=8'b00000000; //Dest
    memory[32]=8'b00000000; //Dest
    memory[33]=8'b00000000; //Dest
    memory[34]=8'b00000000; //Dest
    memory[35]=8'b00000000; //Dest
    memory[36]=8'b00000000; //Dest
    memory[37]=8'b00000000; //Dest
    memory[38]=8'b00100111; //Dest=39

    // check:
        // addq %rax, %rbx 
        memory[39]=8'b01100000; //5 fn
        memory[40]=8'b00110011; //rA=3 rB=3
        // je rbxres  
        memory[41]=8'b01110011; //7 fn=3
        memory[42]=8'b00000000; //Dest
        memory[43]=8'b00000000; //Dest
        memory[44]=8'b00000000; //Dest
        memory[45]=8'b00000000; //Dest
        memory[46]=8'b00000000; //Dest
        memory[47]=8'b00000000; //Dest
        memory[48]=8'b00000000; //Dest
        memory[49]=8'b01111010; //Dest=122
        // addq %rax, %rdx
        memory[50]=8'b01100000; //5 fn
        memory[51]=8'b00000010; //rA=0 rB=2
        // je rdxres 
        memory[52]=8'b01110011; //7 fn=3
        memory[53]=8'b00000000; //Dest
        memory[54]=8'b00000000; //Dest
        memory[55]=8'b00000000; //Dest
        memory[56]=8'b00000000; //Dest
        memory[57]=8'b00000000; //Dest
        memory[58]=8'b00000000; //Dest
        memory[59]=8'b00000000; //Dest
        memory[60]=8'b01111101; //Dest=125
        // jmp loop2 
        memory[61]=8'b01110000; //7 fn=0
        memory[62]=8'b00000000; //Dest
        memory[63]=8'b00000000; //Dest
        memory[64]=8'b00000000; //Dest
        memory[65]=8'b00000000; //Dest
        memory[66]=8'b00000000; //Dest
        memory[67]=8'b00000000; //Dest
        memory[68]=8'b00000000; //Dest
        memory[69]=8'b01000110; //Dest

        // halt
        memory[70]=8'b00000000; // 0 0

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
            instruction = {memory[PC], memory[PC+64'd1], memory[PC+64'd2], memory[PC+64'd3], memory[PC+64'd4], memory[PC+64'd5], memory[PC+64'd6], memory[PC+64'd7], memory[PC+64'd8], memory[PC+64'd9]}; 
    
            //An instruction consists of a 1-byte instruction specifier, 1-byte register specifier, and an 8-byte constant word.

            icode = instruction[0:3];
            ifun = instruction[4:7];


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
            regids = memory[PC+64'd1];
            rA = regids[0:3];
            rB = regids[4:7];
            valP = PC + 64'd2;
        end
        // irmovq
        4'd3: begin
            regids = memory[PC+64'd1];
            rA = regids[0:3];
            rB = regids[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
        end
        // rmmovq
        4'd4: begin
            regids = instruction[8:15];
            rA = regids[0:3];
            rB = regids[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
        end
        // mrmovq
        4'd5: begin
            regids = instruction[8:15];
            rA = regids[0:3];
            rB = regids[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
        end
        // Opq
        4'd6: begin
            regids = instruction[8:15];
            rA = regids[0:3];
            rB = regids[4:7];
            valP = PC + 64'd2;
        end
        // jXX
        4'd7: begin
            valC = instruction[8:71];
            valP = PC + 64'd9;
        end
        // call
        4'd8: begin
            valC = instruction[8:71];
            valP = PC + 64'd9;
        end
        // ret
        4'd9: begin
            valP = PC + 64'd1;
        end
        // pushq
        4'd10: begin
            regids = instruction[8:15];
            rA = regids[0:3];
            rB = regids[4:7];
            valP = PC + 64'd2;
        end
        // popq
        4'd11: begin
            regids = instruction[8:15];
            rA = regids[0:3];
            rB = regids[4:7];
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