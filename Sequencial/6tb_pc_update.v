`timescale 1ns / 1ps
`include "6main_pc_update.v"
module pc_update_tb;

  reg clk = 0;
  reg cnd = 0;
  reg [3:0] icode;
  reg [63:0] valC;
  reg [63:0] valP;
  reg [63:0] valM;
  reg [63:0] pc;

  wire [63:0] updated_pc;

  pc_update pc_upd (
    .clk(clk),
    .cnd(cnd),
    .icode(icode),
    .valC(valC),
    .valP(valP),
    .valM(valM),
    .pc(pc),
    .updated_pc(updated_pc)
  );

  always #5 cl  k = ~clk;

  initial begin
    icode = 4'b0111;
    valC = 64'd100;
    valP = 64'd200;
    valM = 64'd300;
    pc = 64'd400;
    cnd = 1;
    #10;

    icode = 4'b0111;
    valC = 64'd100;
    valP = 64'd200;
    valM = 64'd300;
    pc = 64'd400;
    cnd = 0;
    #10;

    icode = 4'b1000;
    valC = 64'd500;
    valP = 64'd600;
    valM = 64'd700;
    pc = 64'd800;
    #10;

    icode = 4'b1001;
    valC = 64'd900;
    valP = 64'd1000;
    valM = 64'd1100;
    pc = 64'd1200;
    #10;

    icode = 4'b0000;
    valC = 64'd1300;
    valP = 64'd1400;
    valM = 64'd1500;
    pc = 64'd1600;
    #10;

    $finish;
  end

  initial begin
    $monitor("clk=%b, cnd=%b, icode=%b, valC=%d, valP=%d, valM=%d, pc=%d, updated_PC=%d", clk, cnd, icode, valC, valP, valM, pc, updated_pc);
  end

endmodule
