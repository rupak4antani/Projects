module misr_c432_1(N223, N329, N370, N421, N430, N431, N432, s,clk,clk1, N1, N2, N3, N4);

    input N223, N329, N370, N421, N430, N431, N432,clk,clk1;
    input [6:0] N1,N2,N3,N4;
    output reg [3:0] s;

    reg [3:0] q;
    integer i;
    integer count;

    initial
    begin
        count = 0;
        q = 4'b1101; 

    end

    always @(posedge clk1) 
    begin
        if(count == 7)
        begin
            count = -1;
            q <= 4'b1101;

            s[0] = q[0];
            s[1] = q[1];
            s[2] = q[2];
            s[3] = q[3];
        end
        else
        begin 
            q[0] <= N1[count] ^ q[3];
            q[1] <= N2[count] ^ q[0];
            q[2] <= N3[count] ^ q[1];
            q[3] <= N4[count] ^ q[2] ^ q[3];
        end

        count = count + 1;

    end

endmodule

