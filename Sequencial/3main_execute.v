//EXECUTE BLOCK
`timescale 1ns/10ps
`include "alu.v"
// `include "ALU/alu64.v"
// `include "ALU/full_adder.v"
// `include "ALU/add64.v"
// `include "ALU/sub64.v"
// `include "ALU/and64.v"
// `include "ALU/xor64.v"

module execute(clk, icode, ifun, valA, valB, valC, valE, cnd);

    input clk;
    input [3:0] icode;
    input [3:0] ifun;
    input [63:0] valA;
    input [63:0] valB;
    input [63:0] valC;

    output reg [63:0] valE;
    output reg cnd;

    // Condition Code [ZF, SF, OF]
    reg [2:0] CC;
    reg zf;
    reg sf;
    reg of;

    // reg [63:0] aluA, aluB;
    wire signed [63:0]ans;
    reg signed [63:0] ans_;
    wire [2:0] conCode;
    reg [2:0] CC_;
    reg signed [63:0] aluA, aluB;
    reg [1:0] op;



    //Intialisation
    initial 
    begin
        valE = 64'd0;
        cnd = 1'b0;
        CC = 3'd0;
        zf = 0;
        sf = 0;
        of = 0;
    end

    always@(*)
    begin
        if(clk == 1)
        begin
            zf = conCode[2];
            sf = conCode[1];
            of = conCode[0];
        end
    end

    alu_ uut(aluA, aluB, op, ans, conCode);


    always @(*)
    begin
        if(clk ==1)
        begin
            if(icode == IRRMOVQ)
            begin
                valE = valA;
                if(ifun == 4'd0) // unconditional
                begin
                    cnd = 1;
                end
                else if(ifun == 4'd1) // less than equal to
                begin
                    cnd = ((sf^of)| zf);
                end
                else if(ifun == 4'd2) // less than 
                begin
                    cnd = (sf^of);
                end
                else if(ifun == 4'd3) // equal to
                begin
                    cnd = zf;
                end
                else if(ifun == 4'd4) // not equal to
                begin
                    cnd = ~zf;
                end
                else if(ifun == 4'd5) // greater than equal to
                begin
                    cnd = ~(sf^of);
                end
                else if(ifun == 4'd6) // greater than 
                begin
                    cnd = ((~(sf^of))&~zf);
                end
            end
            else if(icode == IIRMOVQ)
            begin
                valE = valC;
            end
            else if(icode == IRMMOVQ)
            begin
                valE = valC+valB;
            end
            else if(icode == IMRMOVQ)
            begin
                valE = valC+valB;
            end
            else if(icode == IOPQ)
            begin
                aluA = valB;
                aluB = valA;
                if(ifun==4'b0000)
                    op = 2'b00;
                else if(ifun==4'b0001)
                    op = 2'b01;
                else if(ifun==4'b0010)
                    op = 2'b10;
                else
                    op = 2'b11;
                // assign ans_ = ans;
                valE = ans;
                // assign CC_ = conCode;
                CC = conCode;
            end
            else if(icode== IJXX)
            begin
                if(ifun == 4'd0)
                begin
                    cnd = 1;
                end
                else if(ifun == 4'd1)
                begin
                    cnd = ((sf^of)| zf);
                end
                else if(ifun == 4'd2)
                begin
                    cnd = (sf^of);
                end
                else if(ifun == 4'd3)
                begin
                    cnd = zf;
                end
                else if(ifun == 4'd4)
                begin
                    cnd = ~zf;
                end
                else if(ifun == 4'd5)
                begin
                    cnd = ~(sf^of);
                end
                else if(ifun == 4'd6)
                begin
                    cnd = ((~(sf^of))&~zf);
                end
            end
            else if(icode == ICALL)
            begin
                valE = -64'd1+valB;
            end
            else if(icode == IRET)
            begin
                valE = 64'd1+valB;
            end
            else if(icode == IPUSHQ)
            begin
                valE = -64'd1+valB;
            end
            else if(icode == IPOPQ)
            begin
                valE = 64'd1+valB;
            end
            
        end
    end

endmodule



module execute(clk, icode, ifun, valC, valA, valB, cnd, valE, ZF, OF, SF);
    input clk;
    input [3:0] icode;
    input [3:0] ifun;
    input [63:0] valA;
    input [63:0] valB;
    input [63:0] valC;

    output reg ZF;
    output reg OF;
    output reg SF;
    
    wire signed [63:0] add_mem;
    wire signed [63:0] sub_mem;
    
    wire signed [63:0] add_out;
    wire signed [63:0] sub_out;
    wire signed [63:0] and_out;
    wire signed [63:0] xor_out;
    // wire OF_alu;

    wire signed [63:0] add_8;
    wire signed [63:0] sub_8;
     
    output reg cnd;
    output reg [63:0] valE;

    // rmmovq, mrmovq
    alu64 ADDmem(add_mem, /*OF_alu, */2'b00, valB, valC);
    alu64 SUBmem(sub_mem, /*OF_alu, */2'b01, valB, valC);

    // OPq
    alu64 ADDop(add_out, /*OF_alu,*/ 2'b00, valB, valA);
    alu64 SUBop(sub_out, /*OF_alu,*/ 2'b01, valA, valB);
    alu64 ANDop(and_out, /*OF_alu,*/ 2'b10, valB, valA);
    alu64 XORop(xor_out, /*OF_alu,*/ 2'b11, valB, valA);

    // pushq, popq, call, ret
    alu64 ADD8(add_8, /*OF_alu,*/ 2'b00, valB, 64'd8);
    alu64 SUB8(sub_8, /*OF_alu,*/ 2'b01, valB, 64'd8);

    always@ (*) begin

            if (icode == 4'b0010) begin // cmovXX
                valE = valA;

                // Evaluating conditions
                if(ifun == 4'b0000) begin // rrmovq
                    cnd = 1'b1;
                end
                else if(ifun == 4'b0001) begin // cmovle
                    cnd = (SF ^ OF) | ZF ? 1'b1 : 1'b0; 
                end
                else if(ifun == 4'b0010) begin // cmovl
                    cnd = (SF ^ OF) ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0011) begin // cmove
                    cnd = ZF ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0100) begin // cmovne
                    cnd = ~ZF ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0101) begin // cmovge
                    cnd = ~(SF ^ OF) ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0110) begin // cmovg
                    cnd = ~(SF ^ OF) & ~ZF ? 1'b1 : 1'b0;
                end

            end
            
            else if (icode == 4'b0011) begin // irmovq
                valE = valC;
            end
            
            else if (icode == 4'b0100) begin // rmmovq
                valE = add_mem;
                // add64(valE, OF, valB, valC);
            end
            
            else if (icode == 4'b0101) begin // mrmovq
                // add64(valE, OF, valB, valC);
                valE = add_mem;
            end
            
            else if (icode == 4'b0110) begin // OPq
                if(ifun == 4'b0000) begin // add
                    valE = add_out;
                end
                else if(ifun == 4'b0001) begin // sub
                    valE = sub_out;
                end
                else if(ifun == 4'b0010) begin // and
                    valE = and_out;
                end
                else if(ifun == 4'b0011) begin // xor
                    valE = xor_out;
                end

                // Setting condition codes
                ZF = valE === 64'b0;
                SF = valE[63] === 1'b1;
                OF = ((valA[63] === 1'b1) == (valB[63] === 1'b1)) && ((valE[63] === 1'b1) != (valA[63] === 1'b1));

                // Setting condition codes
                // Zero flag
                // if(valE == 64'b0) begin
                //     ZF = 1;
                // end
                // else begin
                //     ZF = 0;
                // end

                // // Sign flag
                // if(valE[63] < 1'b0) begin
                //     SF = 1;
                // end
                // else begin
                //     SF = 0;
                // end

                // // Overflow flag
                // if((valA < 1'b0 == valB < 1'b0) && (valE < 1'b0 != valA < 1'b0)) begin
                //     OF = 1;
                // end
                // else begin
                //     OF = 0;
                // end

            end
            
            else if (icode == 4'b0111) begin // jXX
                // Evaluating conditions
                if(ifun == 4'b0000) begin // jmp
                    cnd = 1'b1;
                end
                else if(ifun == 4'b0001) begin // jle
                    cnd = (SF ^ OF) | ZF ? 1'b1 : 1'b0; 
                end
                else if(ifun == 4'b0010) begin // jl
                    cnd = (SF ^ OF) ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0011) begin // je
                    cnd = ZF ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0100) begin // jne
                    cnd = ~ZF ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0101) begin // jge
                    cnd = ~(SF ^ OF) ? 1'b1 : 1'b0;
                end
                else if(ifun == 4'b0110) begin // jg
                    cnd = ~(SF ^ OF) & ~ZF ? 1'b1 : 1'b0;
                end
            end
            
            else if (icode == 4'b1000) begin // call
                valE = sub_8;
                // OF = OF_alu;
                // alu64(valE, OF, 2'b01, valB, 64'd8);
                // valE = valB - 64'b8;
            end
            
            else if (icode == 4'b1001) begin // ret
                // valE = valB + 64'b8;
                // alu64(valE, OF, 2'b00, valB, 64'd8);
                valE = add_8;
                // OF = OF_alu;
            end
            
            else if (icode == 4'b1010) begin // pushq
                // valE = valB - 64'b8;
                // alu64(valE, OF, 2'b01, valB, 64'd8);
                valE = sub_8;
                // OF = OF_alu;
            end
            
            else if (icode == 4'b1011) begin // popq
                // valE = valB + 64'b8;
                // alu64(valE, OF, 2'b00, valB, 64'd8);
                valE = add_8;
                // OF = OF_alu;
            end
        // end
    end
    
    // always@(posedge clk) begin
    //     if(icode==4'b0110) begin
    //         ZF = (valE == 64'b0);
    //         SF = (valE[63] == 1'b1);
    //         OF = ((valA[63] == 1'b1) == (valB[63] == 1'b1)) && ((valE[63] == 1'b1) != (valA[63] == 1'b1));
    //     end
    // end

endmodule
