// `include "full_adder.v"

module sub(
    input signed [63:0] a, 
    input signed [63:0] b,
    output signed [63:0] d,
    output c
);

  wire signed [63:0] b_C;
  wire signed [63:0] c_temp;

  full_adder FULL_ADDER_0(a[0], ~b[0], 1'b1, d[0], c_temp[0]);

  genvar k;
  generate
    for (k = 1; k < 64; k = k + 1) begin
      assign b_C[k] = ~b[k];
      full_adder FULL_ADDER(
        a[k], b_C[k], c_temp[k-1], d[k], c_temp[k]
      );
    end
  endgenerate

  assign c = c_temp[63];

endmodule