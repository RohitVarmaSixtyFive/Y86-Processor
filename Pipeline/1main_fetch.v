module fetchc(
    input clk,
    input [63:0] F_predPC,
    input [3:0] M_icode,
    input [3:0] W_icode,
    input signed [63:0] M_valA,
    input signed [63:0] W_valM,
    input M_Cnd,
    input F_stall,
    input D_stall,
    input D_bubble,
    output reg [63:0] f_predPC,
    output reg [3:0] D_ifun,
    output reg [3:0] D_icode,
    output reg [3:0] D_rA,
    output reg [3:0] D_rB,
    output reg [63:0] D_valC,
    output reg [63:0] D_valP,
    output reg [3:0] D_stat,
    output reg [63:0] PC
);

// Registers
// reg [63:0] PC;
reg [7:0] byte1; // ifun icode
reg [7:0] byte2; // rA rB
reg [3:0] icode, ifun;
reg [63:0] valC;
reg [63:0] valP;
reg is_instruction_valid = 1'b1;
reg pcvalid = 1'b0;
reg halt_prog = 1'b0;
reg [0:3] stat;
reg [3:0] rA, rB;
reg [0:79] instruction; //Instruction encodings range between 1 and 10 bytes
reg [7:0] memory[0:1000]; //size of the array changes based on the size of the total instruction memory
reg [0:7] rArB_Extract; //part of instruction code
reg [0:71] jump_handle;

initial begin
    $readmemb("1.txt", memory);
    #10;
end

// Fetch logic
always @(*)
  begin
    if(M_icode == 4'b0111 & !M_Cnd)
      begin
        PC <= M_valA;
        f_predPC <=M_valA;
      end
    else if(W_icode == 4'b1001 )
      begin
        PC <= W_valM;
        f_predPC <= W_valM;
      end
    else
      PC <= F_predPC;
  end

always @(*) begin
    rA = 4'hF;
    rB = 4'hF;
    // valC=0;
    instruction = {memory[PC], memory[PC+64'd1], memory[PC+64'd9], memory[PC+64'd8], memory[PC+64'd7], memory[PC+64'd6], memory[PC+64'd5], memory[PC+64'd4], memory[PC+64'd3], memory[PC+64'd2]}; 

        icode = instruction[0:3];
        ifun = instruction[4:7];
        // valC=instruction[16:79];

        if(icode == 4'd7 | icode == 4'd8)
            begin
                jump_handle = {memory[PC],memory[PC+8],memory[PC+7],memory[PC+6],memory[PC+5],memory[PC+4],memory[PC+3],memory[PC+2],memory[PC+1]};
                icode = jump_handle[0:3];
                ifun = jump_handle[4:7];
            end
    case (icode)
        4'd0: begin
            halt_prog = 1;
            valP = PC + 64'd1;
            f_predPC = valP;
        end
        // NOP
        4'd1: begin
            valP = PC + 64'd1;
            f_predPC = valP;
        end
        // rrmovq and cmovXX
        4'd2: begin
            rArB_Extract = memory[PC+64'd1];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
            f_predPC = valP;
        end
        // irmovq
        4'd3: begin
            rArB_Extract = memory[PC+64'd1];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];  
            valP = PC + 64'd10;
            f_predPC = valP;
        end
        // rmmovq
        4'd4: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
            f_predPC = valP;
        end
        // mrmovq
        4'd5: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valC = instruction[16:79];
            valP = PC + 64'd10;
            f_predPC = valP;
        end
        // Opq
        4'd6: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
            f_predPC = valP;
        end
        // jXX
        4'd7: begin
            valC = jump_handle[8:71];
            valP = PC + 64'd9;
            f_predPC = valC;
        end
        // call
        4'd8: begin
            valC = jump_handle[8:71];
            valP = PC + 64'd9;
            f_predPC = valC;
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
            f_predPC = valP;
        end
        // popq
        4'd11: begin
            rArB_Extract = instruction[8:15];
            rA = rArB_Extract[0:3];
            rB = rArB_Extract[4:7];
            valP = PC + 64'd2;
            f_predPC = valP;
        end
        // default: begin
        //    is_instruction_valid = 1'b0; // invalid instruction
        // end
        // Add other cases for different instructions...
    endcase

    if (PC > 1023) begin
        pcvalid = 1'b1;
    end
end

always @(*) begin
    stat = 4'b1000;
    case (halt_prog)
        1: stat = 4'b0100; // halt
    endcase

    if (pcvalid == 1) begin 
        stat = 4'b0010; // Memory error
        $display("mem_error");
        $finish; 
    end

    // if (is_instruction_valid == 0) begin 
    //     stat = 4'b0001; // Invalid instruction
    //     $display("instr_invalid");
    //     $finish; 
    // end
end

// D Register update
always @(posedge clk) begin
    if (D_stall == 0 && D_bubble == 1) begin  
        D_icode <= 4'b0001;
        D_ifun <= 4'b0000;
        D_rA <= 4'b1111;
        D_rB <= 4'b1111;
        D_valC <= 64'b0;
        D_valP <= 64'b0;
        D_stat <= 4'b1000;
    end else if (D_stall == 1) begin
        D_icode <= D_icode;
        D_ifun <= D_ifun;
        D_rA <= D_rA;
        D_rB <= D_rB;
        D_valC <= D_valC;
        D_valP <= D_valP;
        D_stat <= D_stat;
    end else begin
        D_icode <= icode;
        D_ifun <= ifun;
        D_rA <= rA;
        D_rB <= rB;
        D_valC <= valC;
        D_valP <= valP;
        D_stat <= stat;
    end
end

endmodule
