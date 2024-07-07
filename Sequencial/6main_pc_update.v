
module pc_update(
  input clk,          
  input cnd,         
  input [3:0] icode,  
  input [63:0] valC,  
  input [63:0] valP,  
  input [63:0] valM,  
  input [63:0] PC,  
  output reg [63:0] updated_pc
);

  always @(*) begin

    case (icode)
      4'b0111: begin // jxx
        if (cnd == 1'b1)  
          updated_pc = valC;
        else 
          updated_pc = valP; 
      end
      4'b1000: updated_pc = valC; // Call 
      4'b1001: updated_pc = valM; // Return 
      default: updated_pc = valP; // Other Stuff
    endcase
  end

endmodule
