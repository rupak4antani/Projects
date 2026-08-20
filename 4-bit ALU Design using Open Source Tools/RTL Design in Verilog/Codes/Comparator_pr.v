module Comparator_pr(a0,a1,a2,a3,b0,b1,b2,b3,eq,gta,gtb,s1,s0);

input a0,a1,a2,a3,b0,b1,b2,b3,s0,s1;
output eq,gta,gtb;

wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12;

xnor xnor1(w1,a0,b0);
xnor xnor2(w2,a1,b1);
xnor xnor3(w3,a2,b2);
xnor xnor4(w4,a3,b3);

and and0(w11,a3,~b3);
and and1(w5,w4,a2,~b2);
and and2(w6,w4,w3,a1,~b1);
and and3(w7,w4,w3,w2,a0,~b0);

and and4(w12,b3,~a3);
and and5(w8,w4,b2,~a2);
and and6(w9,w4,w3,b1,~a1);
and and7(w10,w4,w3,w2,b0,~a0);

or or1(gta,w11,w5,w6,w7);
or or2(gtb,w12,w8,w9,w10);

and and8(eq,w1,w2,w3,w4,~s1,s0);


endmodule
