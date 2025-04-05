`timescale 1ns / 1ps

module barrel(
    input [31:0] a,
    input [7:0] cmd,
    output[31:0] o
);

wire [31:0] b0, b1, b2, b3, b4, b5; 
wire [15:0] B1;
wire [7:0] B2;
wire [3:0] B3;
wire [1:0] B4;
wire B5;
wire p;
wire [4:0] x;
wire c;

and (p, cmd[5], cmd[7], a[31]);  // p: arithmatic right only
not (c, cmd[6]);  // 1 if shift

genvar i, j, k, kk, l, ll, m, mm, n, nn, q;
generate
    
    for (i = 0; i < 32; i = i + 1) begin: io_rev
        mux in_rev (a[31-i], a[i], cmd[5], b0[i]);
        mux out_rev (b5[31-i], b5[i], cmd[5], o[i]);
    end

    for (j = 0; j < 16; j = j + 1) begin: shift_16
        mux sh_16_lsb (b0[j], b0[16+j], cmd[4], b1[j]);
        mux r_16_msb (b0[16+j], b0[j], cmd[4], B1[j]);
        and (x[0], cmd[4], c);
        mux sh_16 (B1[j], p, x[0], b1[16+j]);
    end
    
    for (k = 0; k < 24; k = k + 1) begin: shift_8
        mux sh_8_lsb (b1[k], b1[8+k], cmd[3], b2[k]);
    end
    and (x[1], cmd[3], c);
    for (kk = 0; kk < 8; kk = kk + 1) begin: Shift_8
        mux r_8_msb (b1[24+kk], b1[kk], cmd[3], B2[kk]);     
        mux sh_8_msb (B2[kk], p, x[1], b2[24+kk]);
    end
    
    for (l = 0; l < 28; l = l + 1) begin: shift_4
        mux sh_4_lsb (b2[l], b2[4+l], cmd[2], b3[l]);
    end
    and (x[2], cmd[2], c);
    for (ll = 0; ll < 4; ll = ll + 1) begin: Shift_4
        mux r_4_msb (b2[28+ll], b2[ll], cmd[2], B3[ll]);
        mux sh_4_msb (B3[ll], p, x[2], b3[28+ll]);
    end
    
    for (m = 0; m < 30; m = m + 1) begin: shift_2
        mux sh_2_lsb (b3[m], b3[2+m], cmd[1], b4[m]);
    end
    and (x[3], cmd[1], c);
    for (mm = 0; mm < 2; mm = mm + 1) begin: Shift_2
        mux r_2_msb (b3[30+mm], b3[mm], cmd[1], B4[mm]);
        mux sh_2_msb (B4[mm], p, x[3], b4[30+mm]);
    end
    
    for (n = 0; n < 31; n = n + 1) begin: shift_1
        mux sh_1_lsb (b4[n], b4[1+n], cmd[0], b5[n]);
    end
    and (x[4], cmd[0], c);
    mux r_1_msb (b4[31], b4[0], cmd[0], B5);
    mux sh_1_msb (B5, p, x[4], b5[31]);

endgenerate

endmodule



module mux(
    input x,
    input y,
    input sel,
    output out
);
wire q, w, e;
    and (q, y, sel);
    not (w, sel);
    and (e, x, w);
    or #1 (out, q, e);  
endmodule
