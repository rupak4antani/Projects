module tpg_36_1(
    input rst, clk,
    output reg q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18,
    q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32, q33, q34, q35
);

wire all0;

assign all0 = ~(q0 | q1 | q2 | q3 | q4 | q5 | q6 | q7 | q8 | q9 | q10 | q11 | q12 | q13 | q14 | q15 | 
               q16 | q17 | q18 | q19 | q20 | q21 | q22 | q23 | q24 | q25 | q26 | q27 | q28 | q29 | 
               q30 | q31 | q32 | q33 | q34 | q35);

always@(*)
begin
    if (rst == 1)
    begin
        q0  <= 0;
        q1  <= 0;
        q2  <= 0;
        q3  <= 0;
        q4  <= 0;
        q5  <= 0;
        q6  <= 0;
        q7  <= 0;
        q8  <= 0;
        q9  <= 0;
        q10 <= 0;
        q11 <= 0;
        q12 <= 0;
        q13 <= 0;
        q14 <= 0;
        q15 <= 0;
        q16 <= 0;
        q17 <= 0;
        q18 <= 0;
        q19 <= 0;
        q20 <= 0;
        q21 <= 0;
        q22 <= 0;
        q23 <= 0;
        q24 <= 0;
        q25 <= 0;
        q26 <= 0;
        q27 <= 0;
        q28 <= 0;
        q29 <= 0;
        q30 <= 0;
        q31 <= 0;
        q32 <= 0;
        q33 <= 0;
        q34 <= 0;
        q35 <= 0;
    end
end

always @(posedge clk)
begin
        q0  <= q35;
        q1  <= q0;
        q2  <= q1;
        q3  <= q2;
        q4  <= q3;
        q5  <= q4 ^ q35;
        q6  <= q5;
        q7  <= q6;
        q8  <= q7;
        q9  <= q8;
        q10 <= q9;
        q11 <= q10;
        q12 <= q11 ^ q35;
        q13 <= q12;
        q14 <= q13;
        q15 <= q14;
        q16 <= q15;
        q17 <= q16;
        q18 <= q17;
        q19 <= q18;
        q20 <= q19;
        q21 <= q20;
        q22 <= q21;
        q23 <= q22;
        q24 <= q23;
        q25 <= q24 ^ q35;
        q26 <= q25;
        q27 <= q26;
        q28 <= q27;
        q29 <= q28;
        q30 <= q29;
        q31 <= q30;
        q32 <= q31;
        q33 <= q32;
        q34 <= q33;
        q35 <= q34 | all0;
end

endmodule