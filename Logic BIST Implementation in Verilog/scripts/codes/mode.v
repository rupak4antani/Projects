module mode(
    input wire BIST,
    output wire N1_sel, N4_sel, N8_sel, N11_sel, N14_sel, N17_sel, N21_sel, N24_sel, N27_sel, N30_sel,
                N34_sel, N37_sel, N40_sel, N43_sel, N47_sel, N50_sel, N53_sel, N56_sel, N60_sel, N63_sel,
                N66_sel, N69_sel, N73_sel, N76_sel, N79_sel, N82_sel, N86_sel, N89_sel, N92_sel, N95_sel,
                N99_sel, N102_sel, N105_sel, N108_sel, N112_sel, N115_sel,
    input wire N1, N4, N8, N11, N14, N17, N21, N24, N27, N30,
               N34, N37, N40, N43, N47, N50, N53, N56, N60, N63,
               N66, N69, N73, N76, N79, N82, N86, N89, N92, N95,
               N99, N102, N105, N108, N112, N115,
    input wire N1_1, N4_1, N8_1, N11_1, N14_1, N17_1, N21_1, N24_1, N27_1, N30_1,
               N34_1, N37_1, N40_1, N43_1, N47_1, N50_1, N53_1, N56_1, N60_1, N63_1,
               N66_1, N69_1, N73_1, N76_1, N79_1, N82_1, N86_1, N89_1, N92_1, N95_1,
               N99_1, N102_1, N105_1, N108_1, N112_1, N115_1
);
    // Assign values to _sel based on the value of BIST
    assign N1_sel   = (BIST) ? N1_1   : N1;
    assign N4_sel   = (BIST) ? N4_1   : N4;
    assign N8_sel   = (BIST) ? N8_1   : N8;
    assign N11_sel  = (BIST) ? N11_1  : N11;
    assign N14_sel  = (BIST) ? N14_1  : N14;
    assign N17_sel  = (BIST) ? N17_1  : N17;
    assign N21_sel  = (BIST) ? N21_1  : N21;
    assign N24_sel  = (BIST) ? N24_1  : N24;
    assign N27_sel  = (BIST) ? N27_1  : N27;
    assign N30_sel  = (BIST) ? N30_1  : N30;
    assign N34_sel  = (BIST) ? N34_1  : N34;
    assign N37_sel  = (BIST) ? N37_1  : N37;
    assign N40_sel  = (BIST) ? N40_1  : N40;
    assign N43_sel  = (BIST) ? N43_1  : N43;
    assign N47_sel  = (BIST) ? N47_1  : N47;
    assign N50_sel  = (BIST) ? N50_1  : N50;
    assign N53_sel  = (BIST) ? N53_1  : N53;
    assign N56_sel  = (BIST) ? N56_1  : N56;
    assign N60_sel  = (BIST) ? N60_1  : N60;
    assign N63_sel  = (BIST) ? N63_1  : N63;
    assign N66_sel  = (BIST) ? N66_1  : N66;
    assign N69_sel  = (BIST) ? N69_1  : N69;
    assign N73_sel  = (BIST) ? N73_1  : N73;
    assign N76_sel  = (BIST) ? N76_1  : N76;
    assign N79_sel  = (BIST) ? N79_1  : N79;
    assign N82_sel  = (BIST) ? N82_1  : N82;
    assign N86_sel  = (BIST) ? N86_1  : N86;
    assign N89_sel  = (BIST) ? N89_1  : N89;
    assign N92_sel  = (BIST) ? N92_1  : N92;
    assign N95_sel  = (BIST) ? N95_1  : N95;
    assign N99_sel  = (BIST) ? N99_1  : N99;
    assign N102_sel = (BIST) ? N102_1 : N102;
    assign N105_sel = (BIST) ? N105_1 : N105;
    assign N108_sel = (BIST) ? N108_1 : N108;
    assign N112_sel = (BIST) ? N112_1 : N112;
    assign N115_sel = (BIST) ? N115_1 : N115;

endmodule

