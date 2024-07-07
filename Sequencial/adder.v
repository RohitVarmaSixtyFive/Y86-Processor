// `include "full_adder.v"

module adder(
    input signed [63:0] a,
    input signed [63:0] b,
    output signed [63:0] s,
    output c);

    wire signed [63:0] c_temp;

    full_adder FA(a[0], b[0], 1'b0, s[0], c_temp[0]);
    
    genvar k;
    for(k=1;k<64;k=k+1) begin
        full_adder FA(a[k], b[k], c_temp[k-1], s[k], c_temp[k]);
    end

    assign c=c_temp[63];
endmodule
