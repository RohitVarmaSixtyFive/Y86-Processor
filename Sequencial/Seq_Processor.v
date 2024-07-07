`include "main_fetch.v"
`include "main_decode.v"
`include "main_execute.v"
`include "4main_memory.v"
`include "5main_writeback.v"
`include "6main_pc_update.v"

module combine_tb();

    reg clk;
    reg [63:0] PC;
    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire [63:0] valP;
    wire instr_valid; 
    wire imem_error;
    wire hlt;
    wire [63:0] valA;
    wire [63:0] valB;
    wire [63:0] valE,valM,datamem,memory_address;
    wire [3:0] rB_out;
    wire cnd,dmem_error;
    wire [2:0] cc_out;
    reg [2:0] cc_in;
    wire [63:0] updated_pc;

    main_fetch UUT_fetch(clk, PC, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid, hlt);
    main_decode UUT_decode(clk, icode, rA, rB, valA, valB);
    main_execute UUT_execute(icode,ifun,valA,valB,valC,rB,rB_out,valE,clk,cnd,cc_out,cc_in);
    memory UUT_memory(clk,icode,valA,valE,valP,valM,dmem_error,datamem,memory_address);
    writeback UUT_writeback(clk,icode,rA,rB,cnd,valE,valM,valA);
    pc_update UUT_pc_update(clk,cnd,icode,valC,valP,valM,PC,updated_pc);

    initial begin
        $dumpfile("combine_tb.vcd");
        $dumpvars(0, combine_tb);

        clk = 0;
        PC = 0;
        cc_in[0]=0;
        cc_in[1]=0;
        cc_in[2]=0;

        #10 clk = ~clk;

        // Test Case 1  
        // Fetching a valid instruction
        PC = 0;
        #10;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        $finish;
    end

    always @(*) begin
    PC <= updated_pc;
    end

    always @(*) begin
      cc_in[0] = cc_out[0];
      cc_in[1] = cc_out[1];
      cc_in[2] = cc_out[2];
    end

    initial 
    begin
      $monitor($time, "\tclk = %0d PC = %0d\n\t\t\ticode = %b ifun = %b rA = %b rB = %b valC = %0d valP = %0d imem_error = %d, instr_valid = %d, hlt = %d,valA = %d, valB = %d valE=%d\n,\t\t\tvalM = %d, dmemerror = %d ,cnd=%d", clk, PC, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid, hlt,valA,valB,valE,valM,dmem_error,cnd);
    end

endmodule
