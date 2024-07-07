// `timescale 1ns / 10ps
`include "2main_decode.v"
module decode_tb();

    reg clk;
    reg [3:0] icode;
    reg [3:0] rA;
    reg [3:0] rB;

    wire [63:0] valA;
    wire [63:0] valB;

    main_decode UUT(clk, icode, rA, rB, valA, valB);

    //creating clk
    // initial
    // begin
    //     clk = 0;
    //     repeat (20)  #10 clk = ~clk;
    // end

    initial
    begin
        // $dumpfile("decode_tb.vcd");
        // $dumpvars(0, decode_tb);
        
        clk=0;
        icode=4'd0;
        rA=4'd0;
        rB=4'd0;

    end

    initial
    begin

        #10 clk=~clk;
        icode=4'd11;rA=4'd0;rB=3'd3;

        #10 clk = ~clk;
        icode=4'd3;rA=4'd15;rB=4'd2;

        // #10 
        // icode=4'd6;rA=4'd3;rB=4'd2;

        // #20
        // icode=4'd5;rA=4'd4;rB=4'd10;

        // #20
        // icode=4'd6;rA=4'd11;rB=4'd5;

        // #20
        // icode=4'd7;rA=4'd6;rB=4'd7;

        // #20
        // icode=4'd8;rA=4'd6;rB=4'd7;

        // #20
        // icode=4'd9;rA=4'd7;rB=4'd8;

        // #20
        // icode=4'd10;rA=4'd9;rB=4'd10;

        // #20
        // icode=4'd11;rA=4'd0;rB=4'd1;
    end

    initial 
    begin
		$monitor($time, "\tclk = %d icode = %b rA = %b rB = %b\n\t\t\tvalA = %g valB = %g\n", clk,icode, rA, rB, valA, valB);
	end

endmodule