module phaseshifter_1(
    input q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18,
    q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32, q33, q34, q35,
    output N1, N4, N8, N11, N14, N17, N21, N24, N27, N30, N34, N37, N40, N43, N47, N50, N53, N56, N60, N63,
    N66, N69, N73, N76, N79, N82, N86, N89, N92, N95, N99, N102, N105, N108, N112, N115
);

assign N1 = q0;
assign N4 = q29;
assign N8 = q5^q10^q22;
assign N11 = q1^q2^q3^q5^q7^q12^q15^q17^q18^q21^q22^q25^q27^q31^q32;
assign N14 = q1^q2^q3^q5^q8^q11^q12^q13^q16^q18^q19^q20^q22^q23^q24^q31;
assign N17 = q3^q5^q6^q7^q8^q11^q12^q14^q16^q20^q22^q24^q25^q27^q31^q32^q33;
assign N21 = q6^q9^q11^q16^q19^q25^q27^q34^q35;
assign N24 = q0^q1^q2^q3^q5^q7^q8^q12^q14^q17^q18^q19^q20^q22^q23^q24^q26^q27^q28^q31^q34;
assign N27 = q0^q2^q5^q7^q11^q13^q14^q21^q23^q25^q30^q31^q33^q34^q35;

assign N30 = q7;
assign N34 = q25^q30;
assign N37 = q0^q3^q5^q7^q27^q34;
assign N40 = q1^q2^q4^q6^q7^q9^q14^q15^q18^q19^q22^q27^q29^q34;
assign N43 = q0^q2^q3^q4^q7^q8^q10^q12^q17^q19^q21^q25^q26^q27^q31^q35;
assign N47 = q2^q5^q6^q7^q12^q13^q14^q15^q16^q18^q20^q21^q22^q25^q27^q28^q31^q34;
assign N50 = q0^q1^q2^q3^q5^q8^q9^q12^q13^q18^q23^q26^q28^q35;
assign N53 = q2^q3^q4^q6^q8^q9^q11^q13^q14^q15^q17^q21^q22^q24^q28^q31^q33;
assign N56 = q1^q2^q3^q5^q6^q7^q8^q9^q11^q13^q18^q19^q20^q21^q23^q25^q27^q28^q32;

assign N60 = q14;
assign N63 = q11^q18^q23^q35;
assign N66 = q1^q6^q11^q12^q16^q18^q35;
assign N69 = q1^q6^q9^q11^q12^q13^q15^q18^q19^q20^q24^q25^q26^q27^q30^q31^q32^q35;
assign N73 = q2^q3^q5^q7^q8^q9^q10^q12^q16^q17^q19^q21^q22^q27^q28^q30^q31^q32^q33^q35;
assign N76 = q3^q5^q6^q8^q9^q11^q14^q15^q20^q21^q22^q29^q30^q33;
assign N79 = q0^q1^q2^q5^q7^q8^q9^q13^q15^q16^q18^q20^q21^q22^q23^q24^q25^q26^q27^q29^q31^q32^q35;
assign N82 = q2^q8^q10^q12^q14^q16^q17^q18^q20^q21^q23^q27^q28^q29^q30^q32^q35;
assign N86 = q0^q4^q5^q7^q13^q15^q18^q19^q21^q22^q24^q25^q27^q29^q30^q32^q33^q34^q35;

assign N89 = q19;
assign N92 = q0^q12^q26;
assign N95 = q2^q5^q7^q8^q11^q12^q15^q17^q21^q22^q27^q32^q35;
assign N99 = q1^q2^q3^q6^q8^q9^q10^q12^q13^q14^q21^q28^q30^q31^q34;
assign N102 = q1^q4^q7^q11^q12^q15^q16^q19^q21^q22^q24^q28^q29^q32^q33^q34^q35;
assign N105 = q0^q3^q4^q5^q6^q8^q9^q10^q13^q15^q18^q22^q23^q27^q28^q29^q30^q33^q34^q35;
assign N108 = q1^q3^q4^q6^q7^q8^q11^q14^q15^q16^q17^q18^q20^q25^q26^q29^q30^q32^q33^q34^q35;
assign N112 = q6^q8^q9^q11^q13^q14^q19^q20^q24^q26^q28^q30^q31^q32^q35;
assign N115 = q0^q1^q2^q3^q5^q6^q8^q9^q10^q11^q14^q17^q22^q24^q25^q28^q29^q31^q33;

endmodule
