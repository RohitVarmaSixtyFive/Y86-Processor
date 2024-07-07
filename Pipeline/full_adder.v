module full_adder(
    input a, b, cin,
    output s, cout
);

    wire a_xor_b, ab_and_cin, a_and_b, b_and_cin;

    xor x1(a_xor_b, a, b);
    xor x2(s, a_xor_b, cin); // Sum output here

    and a1(ab_and_cin, a_xor_b, cin);
    and a2(a_and_b, a, b);

    or o1(cout, a_and_b,ab_and_cin); // Carry output here

endmodule