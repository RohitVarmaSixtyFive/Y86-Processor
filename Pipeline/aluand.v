module aluand(out, a, b);
    input signed [63:0] a;
    input signed [63:0] b;
    output signed [63:0] out;
    
    genvar k;
    for(k=0;k<64;k=k+1)
    begin
        and AND(out[k], a[k], b[k]);
    end
endmodule