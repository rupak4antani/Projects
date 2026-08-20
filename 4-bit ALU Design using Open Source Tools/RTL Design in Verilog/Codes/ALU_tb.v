module ALU_tb;

reg [3:0] A,B;
wire [3:0] C,D,X,Y,Z,W,carry,an,S,E;
reg S0,S1;
wire GTA,GTB,EQ;

Mux_4_1 m1(.s0(S0),.s1(S1),.out0(E[0]),.out1(E[1]),.out2(E[2]),.out3(E[3]));

input_enable i1(.e(~S0),.a0(A[0]),.a1(A[1]),.a2(A[2]),.a3(A[3]),.b0(B[0]),.b1(B[1]),.b2(B[2]),.b3(B[3]),.c0(C[0]),.c1(C[1]),.c2(C[2]),.c3(C[3]),.d0(D[0]),.d1(D[1]),.d2(D[2]),.d3(D[3]));
input_enable i2(.e(E[2]),.a0(A[0]),.a1(A[1]),.a2(A[2]),.a3(A[3]),.b0(B[0]),.b1(B[1]),.b2(B[2]),.b3(B[3]),.c0(X[0]),.c1(X[1]),.c2(X[2]),.c3(X[3]),.d0(Y[0]),.d1(Y[1]),.d2(Y[2]),.d3(Y[3]));
input_enable i3(.e(E[3]),.a0(A[0]),.a1(A[1]),.a2(A[2]),.a3(A[3]),.b0(B[0]),.b1(B[1]),.b2(B[2]),.b3(B[3]),.c0(Z[0]),.c1(Z[1]),.c2(Z[2]),.c3(Z[3]),.d0(W[0]),.d1(W[1]),.d2(W[2]),.d3(W[3]));

Adder_Subtractor a1 (.a(C[0]),.b(D[0]),.c0(E[1]),.m(E[1]),.c(carry[0]),.s(S[0]));
Adder_Subtractor a2 (.a(C[1]),.b(D[1]),.c0(carry[0]),.m(E[1]),.c(carry[1]),.s(S[1]));
Adder_Subtractor a3 (.a(C[2]),.b(D[2]),.c0(carry[1]),.m(E[1]),.c(carry[2]),.s(S[2]));
Adder_Subtractor a4 (.a(C[3]),.b(D[3]),.c0(carry[2]),.m(E[1]),.c(carry[3]),.s(S[3]));

Comparator_pr c1(.a0(X[0]),.a1(X[1]),.a2(X[2]),.a3(X[3]),.b0(Y[0]),.b1(Y[1]),.b2(Y[2]),.b3(Y[3]),.eq(EQ),.gta(GTA),.gtb(GTB),.s1(S1),.s0(S0));

and_pr f1(.a0(Z[0]),.a1(Z[1]),.a2(Z[2]),.a3(Z[3]),.b0(W[0]),.b1(W[1]),.b2(W[2]),.b3(W[3]),.c0(an[0]),.c1(an[1]),.c2(an[2]),.c3(an[3]));

always@(S0,S1,A,B)
begin
    $display("S0 = %d, S1= %d, A = %b, B = %b, Sum/Difference = %b, Carry= %d, Eq = %d, GtA= %d, Gtb= %d, AND= %b",S0,S1,A,B,S,carry[3],EQ,GTA,GTB,an);
end

initial
begin
    S0 = 0; S1 = 0; A = 4'b0110; B = 4'b1100; 
    #10 S0 = 0; S1 = 0; A = 4'b1101; B = 4'b0110;
    #10 S0 = 0; S1 = 0; A = 4'b1000; B = 4'b1001;
    #10 S0 = 0; S1 = 1; A = 4'b0110; B = 4'b1100;
    #10 S0 = 0; S1 = 1; A = 4'b0011; B = 4'b1100;
    #10 S0 = 0; S1 = 1; A = 4'b1010; B = 4'b0101;
    #10 S0 = 1; S1 = 0; A = 4'b0110; B = 4'b1100;
    #10 S0 = 1; S1 = 0; A = 4'b1110; B = 4'b1110;
    #10 S0 = 1; S1 = 0; A = 4'b1110; B = 4'b0110;
    #10 S0 = 1; S1 = 1; A = 4'b0110; B = 4'b1100;
    #10 S0 = 1; S1 = 1; A = 4'b1110; B = 4'b0110;
    #10 S0 = 1; S1 = 1; A = 4'b0111; B = 4'b1000;
end

endmodule
