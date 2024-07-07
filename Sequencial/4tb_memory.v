`include "4main_memory.v"
module memory_tb;
    reg clk;
    reg [3:0] icode;
    reg [63:0] valA;
    reg [63:0] valE;
    reg [63:0] valP;
    output [63:0] valM;
    output dmem_error;
    output [63:0] datamem;
    output [63:0] memory_address;

    memory uut(
        .clk(clk),
        .icode(icode),
        .valA(valA),
        .valE(valE),
        .valP(valP),
        .valM(valM),
        .dmem_error(dmem_error),
        .datamem(datamem),
        .memory_address(memory_address)
    );

    // initial
    // begin
    //     clk = 0;
    //     #10 clk = ~clk;
    // end

    initial 
    begin
        // $dumpfile("memory_tb.vcd");
        // $dumpvars(0, memory_tb);
        clk=0;
        icode=4'd3;
        valA=64'd4;
        valE=64'd10;
        valP=64'd0;
    end

    initial 
    begin
        // #10
        icode = 4'd5; valA = 64'd15; valE = 64'd2 ;valP = 64'd10;
        #10 clk = ~clk;
        // icode = 4'd4; valA = 64'd7 ;valE = 64'd1;valP = 64'd10;
    end 
    
    initial
        $monitor("clk = %d icode = %b valA = %g valE = %g valP = %g valM = %g dmem_error = %d datamem = %g memory_address = %g\n",clk,icode,valA,valE,valP,valM,dmem_error,datamem,memory_address);

endmodule