module and_pr(a0,a1,a2,a3,b0,b1,b2,b3,c0,c1,c2,c3);

input a0,a1,a2,a3,b0,b1,b2,b3;
output c0,c1,c2,c3;

and and1(c0,a0,b0);
and and2(c1,a1,b1);
and and3(c2,a2,b2);
and and4(c3,a3,b3);

endmodule
