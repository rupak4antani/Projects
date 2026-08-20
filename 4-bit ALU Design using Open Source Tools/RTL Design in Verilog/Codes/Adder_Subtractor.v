module Adder_Subtractor(a,b,c0,m,s,c);

input a,b,m,c0;
output s,c;

wire w1,w2,w3,w4,w5;

xor xor1(w1,m,b);
xor xor2(w2,a,w1);
xor xor3(s,w2,c0);
and and1(w3,a,w1);
and and2(w4,w2,c0);
or or1(c,w3,w4);


endmodule
