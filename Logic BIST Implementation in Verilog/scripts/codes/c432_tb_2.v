module c432_tb_2;

reg rst,clk,clk1;
reg N1,N4,N8,N11,N14,N17,N21,N24,N27,N30,
             N34,N37,N40,N43,N47,N50,N53,N56,N60,N63,
             N66,N69,N73,N76,N79,N82,N86,N89,N92,N95,
             N99,N102,N105,N108,N112,N115;

wire q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18,
    q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32, q33, q34, q35;

wire N1_1, N4_1, N8_1, N11_1, N14_1, N17_1, N21_1, N24_1, N27_1, N30_1,
     N34_1, N37_1, N40_1, N43_1, N47_1, N50_1, N53_1, N56_1, N60_1, N63_1,
     N66_1, N69_1, N73_1, N76_1, N79_1, N82_1, N86_1, N89_1, N92_1, N95_1,
     N99_1, N102_1, N105_1, N108_1, N112_1, N115_1;

wire N1_sel, N4_sel, N8_sel, N11_sel, N14_sel, N17_sel, N21_sel, N24_sel, N27_sel, N30_sel,
     N34_sel, N37_sel, N40_sel, N43_sel, N47_sel, N50_sel, N53_sel, N56_sel, N60_sel, N63_sel,
     N66_sel, N69_sel, N73_sel, N76_sel, N79_sel, N82_sel, N86_sel, N89_sel, N92_sel, N95_sel,
     N99_sel, N102_sel, N105_sel, N108_sel, N112_sel, N115_sel;

wire [35:0] memory_N;
reg [6:0] N111,N22,N33,N44;

reg BIST;
wire [35:0] N;
wire N223,N329,N370,N421,N430,N431,N432;
wire [3:0] s;
wire [3:0] memory_s;
wire found;
reg error;

integer count = 0;



tpg_36_1 t2(.rst(rst), .clk(clk), .q0(q0), .q1(q1), .q2(q2),  .q3(q3), .q4(q4), .q5(q5), .q6(q6), .q7(q7), .q8(q8),
         .q9(q9), .q10(q10), .q11(q11), .q12(q12), .q13(q13), .q14(q14), .q15(q15), .q16(q16), .q17(q17), .q18(q18),
         .q19(q19), .q20(q20), .q21(q21), .q22(q22), .q23(q23), .q24(q24), .q25(q25), .q26(q26), .q27(q27), .q28(q28), .q29(q29),
         .q30(q30), .q31(q31), .q32(q32), .q33(q33), .q34(q34), .q35(q35));


phaseshifter_1 p1(.q0(q0), .q1(q1), .q2(q2), .q3(q3), .q4(q4), .q5(q5), .q6(q6), .q7(q7), .q8(q8),
         .q9(q9), .q10(q10), .q11(q11), .q12(q12), .q13(q13), .q14(q14), .q15(q15), .q16(q16), .q17(q17), .q18(q18),
         .q19(q19), .q20(q20), .q21(q21), .q22(q22), .q23(q23), .q24(q24), .q25(q25), .q26(q26), .q27(q27), .q28(q28), .q29(q29),
         .q30(q30), .q31(q31), .q32(q32), .q33(q33), .q34(q34), .q35(q35),
          .N1(N1_1), .N4(N4_1), .N8(N8_1), .N11(N11_1), .N14(N14_1), .N17(N17_1), .N21(N21_1), .N24(N24_1), .N27(N27_1), .N30(N30_1),
         .N34(N34_1), .N37(N37_1), .N40(N40_1), .N43(N43_1), .N47(N47_1), .N50(N50_1), .N53(N53_1), .N56(N56_1), .N60(N60_1), .N63(N63_1),
         .N66(N66_1), .N69(N69_1), .N73(N73_1), .N76(N76_1), .N79(N79_1), .N82(N82_1), .N86(N86_1), .N89(N89_1), .N92(N92_1), .N95(N95_1),
         .N99(N99_1), .N102(N102_1), .N105(N105_1), .N108(N108_1), .N112(N112_1), .N115(N115_1));

mode m1 (
        .BIST(BIST),
        .N1_sel(N1_sel), .N4_sel(N4_sel), .N8_sel(N8_sel), .N11_sel(N11_sel), .N14_sel(N14_sel), 
        .N17_sel(N17_sel), .N21_sel(N21_sel), .N24_sel(N24_sel), .N27_sel(N27_sel), .N30_sel(N30_sel),
        .N34_sel(N34_sel), .N37_sel(N37_sel), .N40_sel(N40_sel), .N43_sel(N43_sel), .N47_sel(N47_sel), 
        .N50_sel(N50_sel), .N53_sel(N53_sel), .N56_sel(N56_sel), .N60_sel(N60_sel), .N63_sel(N63_sel),
        .N66_sel(N66_sel), .N69_sel(N69_sel), .N73_sel(N73_sel), .N76_sel(N76_sel), .N79_sel(N79_sel), 
        .N82_sel(N82_sel), .N86_sel(N86_sel), .N89_sel(N89_sel), .N92_sel(N92_sel), .N95_sel(N95_sel),
        .N99_sel(N99_sel), .N102_sel(N102_sel), .N105_sel(N105_sel), .N108_sel(N108_sel), 
        .N112_sel(N112_sel), .N115_sel(N115_sel),
        .N1(N1), .N4(N4), .N8(N8), .N11(N11), .N14(N14), 
        .N17(N17), .N21(N21), .N24(N24), .N27(N27), .N30(N30),
        .N34(N34), .N37(N37), .N40(N40), .N43(N43), .N47(N47), 
        .N50(N50), .N53(N53), .N56(N56), .N60(N60), .N63(N63),
        .N66(N66), .N69(N69), .N73(N73), .N76(N76), .N79(N79), 
        .N82(N82), .N86(N86), .N89(N89), .N92(N92), .N95(N95),
        .N99(N99), .N102(N102), .N105(N105), .N108(N108), 
        .N112(N112), .N115(N115),
        .N1_1(N1_1), .N4_1(N4_1), .N8_1(N8_1), .N11_1(N11_1), .N14_1(N14_1), 
        .N17_1(N17_1), .N21_1(N21_1), .N24_1(N24_1), .N27_1(N27_1), .N30_1(N30_1),
        .N34_1(N34_1), .N37_1(N37_1), .N40_1(N40_1), .N43_1(N43_1), .N47_1(N47_1), 
        .N50_1(N50_1), .N53_1(N53_1), .N56_1(N56_1), .N60_1(N60_1), .N63_1(N63_1),
        .N66_1(N66_1), .N69_1(N69_1), .N73_1(N73_1), .N76_1(N76_1), .N79_1(N79_1), 
        .N82_1(N82_1), .N86_1(N86_1), .N89_1(N89_1), .N92_1(N92_1), .N95_1(N95_1),
        .N99_1(N99_1), .N102_1(N102_1), .N105_1(N105_1), .N108_1(N108_1), 
        .N112_1(N112_1), .N115_1(N115_1)
    );


c432_sa c3(.N1(N1_sel), .N4(N4_sel), .N8(N8_sel), .N11(N11_sel), .N14(N14_sel), .N17(N17_sel), .N21(N21_sel), .N24(N24_sel), .N27(N27_sel), .N30(N30_sel),
         .N34(N34_sel), .N37(N37_sel), .N40(N40_sel), .N43(N43_sel), .N47(N47_sel), .N50(N50_sel), .N53(N53_sel), .N56(N56_sel), .N60(N60_sel), .N63(N63_sel),
         .N66(N66_sel), .N69(N69_sel), .N73(N73_sel), .N76(N76_sel), .N79(N79_sel), .N82(N82_sel), .N86(N86_sel), .N89(N89_sel), .N92(N92_sel), .N95(N95_sel),
         .N99(N99_sel), .N102(N102_sel), .N105(N105_sel), .N108(N108_sel), .N112(N112_sel), .N115(N115_sel), .N223(N223), .N329(N329), .N370(N370),
         .N421(N421), .N430(N430), .N431(N431), .N432(N432));


misr_c432_1 m2(.N223(N223), .N329(N329), .N370(N370), .N421(N421), .N430(N430), .N431(N431), .N432(N432), .s(s),.clk(clk),.clk1(clk1),.N1(N111),.N2(N22),.N3(N33),.N4(N44));

bist_controller b3(.clk(clk),.N(N), .s(s), .found(found),.memory_s(memory_s),.memory_N(memory_N));

always #8 clk = ~clk;
always #1 clk1 = ~clk1;

always@(*)
begin
    if(count > 2)
    begin
        error = 1;
    end
    else
    begin
        error = 0;
    end
end

always@(posedge clk)
    begin
        N111[0] <= N223;
        N111[1] <= N329;
        N111[2] <= N370;
        N111[3] <= N421;
        N111[4] <= N430;
        N111[5] <= N431;
        N111[6] <= N432;

        N22[0] <= N111[0];
        N22[1] <= N111[1];
        N22[2] <= N111[2];
        N22[3] <= N111[3];
        N22[4] <= N111[4];
        N22[5] <= N111[5];
        N22[6] <= N111[6];

        N33[0] <= N22[0];
        N33[1] <= N22[1];
        N33[2] <= N22[2];
        N33[3] <= N22[3];
        N33[4] <= N22[4];
        N33[5] <= N22[5];
        N33[6] <= N22[6];

        N44[0] <= N33[0];
        N44[1] <= N33[1];
        N44[2] <= N33[2];
        N44[3] <= N33[3];
        N44[4] <= N33[4];
        N44[5] <= N33[5];
        N44[6] <= N33[6];

        if(found == 0)
        begin
            count = count + 1;
        end
    end

initial
begin

    clk = 0; rst = 1; BIST = 1;
    #8 rst = 0; clk1 = 1; N111[0] = N223;  N111[1] = N329;    N111[2] = N370;    N111[3] = N421;    N111[4] = N430;    N111[5] = N431;    N111[6] = N432; N22 = 0; N33 = 0;  N44 = 0;
    //N1 = 0; N4 = 0; N8 = 0; N11 =0; N14 = 0; N17 = 0; 

    #380 $finish;

end

assign N[0] = N1_sel;
assign N[1] = N4_sel;
assign N[2] = N8_sel;
assign N[3] = N11_sel;
assign N[4] = N14_sel;
assign N[5] = N17_sel;
assign N[6] = N21_sel;
assign N[7] = N24_sel;
assign N[8] = N27_sel;
assign N[9] = N30_sel;
assign N[10] = N34_sel;
assign N[11] = N37_sel;
assign N[12] = N40_sel;
assign N[13] = N43_sel;
assign N[14] = N47_sel;
assign N[15] = N50_sel;
assign N[16] = N53_sel;
assign N[17] = N56_sel;
assign N[18] = N60_sel;
assign N[19] = N63_sel;
assign N[20] = N66_sel;
assign N[21] = N69_sel;
assign N[22] = N73_sel;
assign N[23] = N76_sel;
assign N[24] = N79_sel;
assign N[25] = N82_sel;
assign N[26] = N86_sel;
assign N[27] = N89_sel;
assign N[28] = N92_sel;
assign N[29] = N95_sel;
assign N[30] = N99_sel;
assign N[31] = N102_sel;
assign N[32] = N105_sel;
assign N[33] = N108_sel;
assign N[34] = N112_sel;
assign N[35] = N115_sel;


endmodule




