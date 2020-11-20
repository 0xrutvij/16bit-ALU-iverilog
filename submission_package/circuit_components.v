/**************************************************************
* Cohort Name: Trohoc                                         *
* Authors: Anindita Palit, Emory Blair, Khalid Dakak,         *
*          Rutvij Shah and Ryan Radloff.                      *
* Github repo: https://github.com/0xrutvij/16bit-ALU-iverilog *
* Date: 11/19/2020                                            *
**************************************************************/

`include "basic.v"
/**********************************
*****      Register16         *****
**********************************/

module REG16(inp, f_outp, clk, reset);
    input [15:0] inp;
    input clk;
    input reset;
    wire[15:0] outp;
    output [15:0] f_outp; reg [15:0] f_outp;

    REG4 reg1(inp[15:12], outp[15:12], clk, reset),
         reg2(inp[11:8], outp[11:8], clk, reset),
         reg3(inp[7:4], outp[7:4], clk, reset),
         reg4(inp[3:0], outp[3:0], clk, reset);

    always @*
    begin
        f_outp = outp;
    end
endmodule

/**********************************
*****      Register4          *****
**********************************/
module REG4(inp, f_outp, clk, reset);
    input [3:0] inp; wire [3:0] inp;
    input clk; wire clk;
    input reset;
    wire [3:0] outp;
    output[3:0] f_outp; reg[3:0] f_outp;

    DFF the_reg [3:0] (clk, inp, outp, reset);
    always @*
    begin
        f_outp = outp;
    end
endmodule


/**********************************
*****      AND GATE       *********
**********************************/

// 16-bit AND //
module bit16_and (out, a, b);
    input [15:0] a, b;
    output [15:0] out;

    bit8_and t1(out[15:8], a[15:8], b[15:8]),
             t2(out[7:0], a[7:0], b[7:0]);
endmodule

/**********************************
*****      NOT GATE       *********
**********************************/

// 16-bit NOT //
module bit16_not (out, a);
    input [15:0] a;
    output [15:0] out;

    bit8_not t1(out[15:8], a[15:8]),
             t2(out[7:0], a[7:0]);
endmodule

/**********************************
*****      OR GATE        *********
**********************************/

// 16-bit OR //
module bit16_or (out, a, b);
    input [15:0] a, b;
    output [15:0] out;

    bit8_or t1(out[15:8], a[15:8], b[15:8]),
            t2(out[7:0], a[7:0], b[7:0]);
endmodule

/**********************************
*****      NOR GATE      *********
**********************************/

module bit16_nor (out, a, b);
    input [15:0] a, b;
    output [15:0] out;
    wire   [15:0] connect;

    bit16_or t1 (connect, a, b);
    bit16_not t2 (out, connect);
endmodule

/**********************************
*****      NAND GATE      *********
**********************************/

module bit16_nand (out, a, b);
    input [15:0] a, b;
    output [15:0] out;
    wire   [15:0] connect;

    bit16_and t1 (connect, a, b);
    bit16_not t2 (out, connect);
endmodule

/**********************************
*****      XOR GATE       *********
**********************************/

// 16-bit XOR //
module bit16_xor (out, a, b);
    input [15:0] a, b;
    output [15:0] out;

    bit8_xor t1(out[15:8], a[15:8], b[15:8]),
             t2(out[7:0], a[7:0], b[7:0]);
endmodule

/**********************************
*****      XNOR GATE      *********
**********************************/

module bit16_xnor (out, a, b);
    input [15:0] a, b;
    output [15:0] out;
    wire   [15:0] connect;

    bit16_xor t1 (connect, a, b);
    bit16_not t2 (out, connect);
endmodule

/***************************
****** 16 Bit-Adder ********
****************************/

module bit16_adder(num1, num2, mode, error, sum);

input [15:0] num1; wire [15:0] num1;
input [15:0] num2; wire [15:0] num2;
input [15:0] mode; wire [15:0] mode;

output [15:0] sum; wire [15:0] sum;
output error; wire error;
wire carry;
wire[16:0] Cin;
wire[15:0] Cout;
wire[15:0] modB;

assign Cin[0]=mode[0];
assign Cin[16:1]=Cout[15:0];


assign carry=Cout[15];
assign error = mode[0] ^ carry;
assign modB[15:0] = num2[15:0] ^ mode[15:0];

add_full FA[15:0] (num1[15:0],modB[15:0],Cin[15:0],Cout[15:0],sum[15:0]);

endmodule

//Multiplier & Divisor
//Behavioral for now, may change later
/**********************************
*****      Multiplier       *******
**********************************/
module multiplier_16bit(a, b, out, error);
    input [15:0] a, b;
    output [15:0] out; reg [15:0] out;
    output error; reg error;
    //output error; wire error;
    reg [31:0] mult;
    integer i, j;

    always @(a, b)
    begin
        mult = a*b;
        error = 0;
        for (i = 31; i > 15; i = i - 1)
        begin
            error = error | mult[i];
            out[i-16] = mult[i-16];
        end
    end
endmodule

/**********************************
*****      Divider         ********
**********************************/
module divider_16bit(a, b, out, error);
    input [15:0] a, b;
    output [15:0] out; reg [15:0] out;
    output error; reg error;
    //output error; wire error;
    integer i, j;

    always @(a, b)
    begin
        out = a/b;
        error = ~(|b);
    end
endmodule

/**********************************
*****      Modulus         ********
**********************************/
module modulus_16bit(a, b, out, error);
    input [15:0] a, b;
    output [15:0] out; reg [15:0] out;
    output error; reg error;
    //output error; wire error;
    integer i, j;

    always @(a, b)
    begin
        out = a%b;
        error = ~(|b);
    end
endmodule

/**********************************
*****      ShiftRight       *******
**********************************/

module shiftRight(out, in, shamt);
    output [15:0] out; wire [15:0] out;
    input  [15:0] in; wire [15:0] in;
    input  [3:0] shamt; wire [3:0] shamt;

    wire [15:0] a0, a1, a2;

    //Shift by 0 or 1 bits
    MUX2 lsb(a0, shamt[0], in, {1'b0, in[15:1]});
    //Shift by 0 or 2 bits
    MUX2 lmsb(a1, shamt[1], a0, {2'b0, a0[15:2]});
    //Shift by 0 or 4 bits
    MUX2 umsb(a2, shamt[2], a1, {4'b0, a1[15:4]});
    //Shift by 0 or 8 bits
    MUX2 msb(out, shamt[3], a2, {8'b0, a2[15:8]});
endmodule

/**********************************
*****      ShiftLeft       *******
**********************************/

module shiftLeft(out, in, shamt);
    output [15:0] out; wire [15:0] out;
    input  [15:0] in; wire [15:0] in;
    input  [3:0] shamt; wire [3:0] shamt;

    wire [15:0] a0, a1, a2;

    //Shift by 0 or 1 bits
    MUX2 lsb(a0, shamt[0], in, {in[14:0], 1'b0});
    //Shift by 0 or 2 bits
    MUX2 lmsb(a1, shamt[1], a0, {a0[13:0], 2'b0});
    //Shift by 0 or 4 bits
    MUX2 umsb(a2, shamt[2], a1, {a1[11:0], 4'b0});
    //Shift by 0 or 8 bits
    MUX2 msb(out, shamt[3], a2, {a2[7:0], 8'b0});
endmodule
