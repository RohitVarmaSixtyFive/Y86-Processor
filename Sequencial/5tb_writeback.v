module writeback_tb();

    reg clk;
    reg [3:0] icode;
    reg [3:0] rA;
    reg [3:0] rB;
    reg cnd;
    reg [63:0] valE;
    reg [63:0] valM;
    reg [63:0] valA;

    writeback UUT(clk, icode, rA, rB, cnd, valE, valM,valA);


    initial begin

        // $dumpfile("writeback_tb.vcd");
        // $dumpvars(0, writeback_tb);
        clk=0;
    end

    initial 
    begin
        // #10 clk = ~clk; 
        icode = 4'd3;
        rA = 4'd15;
        rB = 4'd3;
        cnd = 0;
        valE = 64'd216;
        valM = 64'd0;
        valA = 64'd0;
        #10 clk = ~clk;
        #10 clk = ~clk;

        icode = 4'd3;
        rA = 4'd11;
        rB = 4'd2;
        cnd = 0;
        valE = 64'd512;
        valM = 64'd0;
        valA = 64'd0;
        // Add more test cases here...

    end

    initial begin
        $monitor($time, "\tclk = %d icode = %b rA = %b rB = %b Cnd = %b valE = %g valM = %g\n", clk, icode, rA, rB, cnd, valE, valM);
    end
endmodule