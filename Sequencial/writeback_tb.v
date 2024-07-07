
// module writeback_tb();

//     reg clk;
//     reg [3:0] icode;
//     reg [3:0] rA;
//     reg [3:0] rB;
//     reg cnd;
//     reg [63:0] valE;
//     reg [63:0] valM;

//     writeback UUT(clk, icode, rA, rB, cnd, valE, valM);


//     initial
//     begin

//         $dumpfile("writeback_tb.vcd");
//         $dumpvars(0, writeback_tb);

//         clk=0;
//         icode=4'd0;
//         rA=4'd0;
//         rB=4'd0;
//         cnd=0;
//         valE=64'd0;
//         valM=64'd0;

//     end

//     initial
//     begin

//         #10 clk = ~clk; 
//         icode=4'd2;rA=4'd0;rB=4'd1;cnd=0;valE=64'd20;valM=64'd50;
//         #10 clk = ~clk;
//         #10 clk = ~clk;
//         // #20
//         // icode=4'd2;rA=4'd0;rB=4'd1;cnd=1;valE=64'd20;valM=64'd50;

//         // #20
//         // icode=4'd3;rA=4'd1;rB=4'd2;cnd=0;valE=64'd100;valM=64'd100;

//         // #20
//         // icode=4'd3;rA=4'd1;rB=4'd2;cnd=1;valE=64'd100;valM=64'd100;

//         // #20
//         // icode=4'd4;rA=4'd3;rB=4'd4;cnd=1;valE=64'd256;valM=64'd10;

//         // #20
//         // icode=4'd5;rA=4'd5;rB=4'd4;cnd=1;valE=64'd1024;valM=64'd51;

//         // #20
//         // icode=4'd6;rA=4'd6;rB=4'd7;cnd=0;valE=64'd91;valM=64'd1;

//         // #20
//         // icode=4'd7;rA=4'd8;rB=4'd7;cnd=0;valE=64'd34;valM=64'd0;

//         // #20
//         // icode=4'd8;rA=4'd1;rB=4'd9;cnd=1;valE=64'd720;valM=64'd3;

//         // #20
//         // icode=4'd9;rA=4'd8;rB=4'd10;cnd=0;valE=64'd2222;valM=64'd189302;

//         // #20
//         // icode=4'd10;rA=4'd11;rB=4'd12;cnd=1;valE=64'd77821;valM=64'd3321;

//         // #20
//         // icode=4'd11;rA=4'd13;rB=4'd14;cnd=1;valE=64'd728782;valM=64'd5849;
        
//     end

//     initial 
//     begin
//         $monitor($time, "\tclk = %d icode = %b rA = %b rB = %b Cnd = %b valE = %g valM = %g\n",clk,icode,rA,rB,cnd,valE,valM);
//     end
// endmodule

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

        $dumpfile("writeback_tb.vcd");
        $dumpvars(0, writeback_tb);
        clk=0;
    end

    initial 
    begin
        #10 clk = ~clk; 
        icode = 4'd11;
        rA = 4'd0;
        rB = 4'd1;
        cnd = 0;
        valE = 64'd20;
        valM = 64'd50;
        valA = 64'd30;
        #10 clk = ~clk;
        #10 clk = ~clk;

        // Add more test cases here...

    end

    initial begin
        $monitor($time, "\tclk = %d icode = %b rA = %b rB = %b Cnd = %b valE = %g valM = %g\n", clk, icode, rA, rB, cnd, valE, valM);
    end
endmodule