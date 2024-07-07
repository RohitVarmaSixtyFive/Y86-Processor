`timescale 1ns / 10ps

module fetch_tb();

  reg clk;
  reg [63:0] PC;
  
  wire [3:0] icode;
  wire [3:0] ifun;

  wire [3:0] rA;
  wire [3:0] rB; 

  wire [63:0] valC;
  wire [63:0] valP;

  output imem_error;
  output instr_valid;
  output hlt;

  fetch UUT(clk, PC, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid, hlt);

  //creating clk
  initial
  begin
    clk = 0;
    repeat (25)  #10 clk = ~clk;
  end

  initial
  begin

    $dumpfile("fetch_tb.vcd");
    $dumpvars(0, fetch_tb);

    clk=0;
    PC=64'd0;

  end
  
  initial 
  begin 

    #10 
    PC=64'd0; 
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20
    PC=valP;
    
    #20     
    PC=valP;
    
    #20
    PC=64'd1024;    
    
  end 
  
  initial 
  begin
    $monitor($time, "\tclk = %d PC = %g\n\t\t\ticode = %b ifun = %b rA = %b rB = %b valC = %g valP = %g imem_error = %d, instr_valid = %d, hlt = %d\n",clk,PC,icode,ifun,rA,rB,valC,valP,imem_error, instr_valid, hlt);
  end
endmodule