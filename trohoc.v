// Khalid Dakak
// Anindita Palit
// Emory Blair
// Rutvij Shah
// Ryan Radloff

/**********************************
*****      AND GATEs      *********
**********************************/

// 4-bit AND //
module bit4_and(out, a, b);
    input[3:0] a, b;
    output[3:0] out;
    
    assign out[3] = a[3] & b[3];
    assign out[2] = a[2] & b[2];
    assign out[1] = a[1] & b[1];
    assign out[0] = a[0] & b[0];

endmodule


// 8-bit AND //
module bit8_and (out, a, b);
    input [7:0] a, b;
    output [7:0] out;

    bit4_and t1(out[7:4], a[7:4], b[7:4]),
             t2(out[3:0], a[3:0], b[3:0]);
    
endmodule


// 16-bit AND //
module bit16_and (out, a, b);
    input [15:0] a, b;
    output [15:0] out;

    bit8_and t1(out[15:8], a[15:8], b[15:8]),
             t2(out[7:0], a[7:0], b[7:0]);
endmodule

/**********************************
*****      NOT GATEs      *********
**********************************/

// 4-bit NOT //
module bit4_not(out, a);
    input[3:0] a;
    output[3:0] out;
    
    assign out[3] = ~a[3];
    assign out[2] = ~a[2];
    assign out[1] = ~a[1];
    assign out[0] = ~a[0];

endmodule


// 8-bit NOT //
module bit8_not (out, a);
    input [7:0] a;
    output [7:0] out;

    bit4_not t1(out[7:4], a[7:4]),
             t2(out[3:0], a[3:0]);
    
endmodule


// 16-bit NOT //
module bit16_not (out, a);
    input [15:0] a;
    output [15:0] out;

    bit8_not t1(out[15:8], a[15:8]),
             t2(out[7:0], a[7:0]);
endmodule

/**********************************
*****      OR GATEs      *********
**********************************/

// 4-bit OR //
module bit4_or(out, a, b);
    input[3:0] a, b;
    output[3:0] out;
    
    assign out[3] = a[3] | b[3];
    assign out[2] = a[2] | b[2];
    assign out[1] = a[1] | b[1];
    assign out[0] = a[0] | b[0];

endmodule


// 8-bit OR //
module bit8_or (out, a, b);
    input [7:0] a, b;
    output [7:0] out;

    bit4_or t1(out[7:4], a[7:4], b[7:4]),
            t2(out[3:0], a[3:0], b[3:0]);
    
endmodule


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
*****      XOR GATEs      *********
**********************************/

// 4-bit XOR //
module bit4_xor(out, a, b);
    input[3:0] a, b;
    output[3:0] out;
    
    assign out[3] = a[3] ^ b[3];
    assign out[2] = a[2] ^ b[2];
    assign out[1] = a[1] ^ b[1];
    assign out[0] = a[0] ^ b[0];

endmodule


// 8-bit XOR //
module bit8_xor (out, a, b);
    input [7:0] a, b;
    output [7:0] out;

    bit4_xor t1(out[7:4], a[7:4], b[7:4]),
             t2(out[3:0], a[3:0], b[3:0]);
    
endmodule


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
*******Half-Adder***********
****************************/

module add_half (input a, b, output c_out, sum);

    xor g1(sum, a, b);
    and g2(c_out, a, b);

endmodule

/***************************
*******Full-Adder***********
****************************/

module add_full (input a, b, c_in, output c_out, sum);

    wire w1, w2, w3;
    add_half m1(a, b, w1, w2);
    add_half m2(w2, c_in, w3, sum);
    or(c_out, w1, w3);

endmodule

/***************************
****** 16 Bit-Adder ********
****************************/

module bit16_adder(num1, num2, mode, carry, sum);

input [15:0] num1; wire [15:0] num1;
input [15:0] num2; wire [15:0] num2;
input [15:0] mode; wire [15:0] mode;

output [15:0] sum; wire [15:0] sum;
output carry; wire carry;

wire[16:0] Cin;
wire[15:0] Cout;
wire[15:0] modB;

assign Cin[0]=mode[0];
assign Cin[16:1]=Cout[15:0];


assign carry=Cout[15];
assign modB[15:0] = num2[15:0] ^ mode[15:0];

add_full FA[15:0] (num1[15:0],modB[15:0],Cin[15:0],Cout[15:0],sum[15:0]);

endmodule

/**********************************
*****      TESTBENCH       ********
**********************************/

// Test Bench //
module testbench();

    reg [15:0] a, b;
    reg [16:0] over;
    wire [15:0] out [0:9];
    reg [15:0]mode;
    bit16_and and_test(out[0], a, b);
    bit16_nand nand_test(out[5], a, b);
    bit16_not not_t1(out[1], a),
              not_t2(out[2], b);
    bit16_or or_test(out[3], a, b);
    bit16_nor nor_test(out[4], a, b);
    bit16_xor xor_test(out[6], a, b);
    bit16_xnor xnor_test(out[7], a, b);
    bit16_adder adder_test(a, b, mode[15:0], out[8][0], out[9]);

    initial begin
        a = 'b0101001011001001; //21193
        b = 'b0000110100111110; //3390
        mode = 'b1111111111111111;
        #7;
        $display("AND a & b: %16b", out[0]);
        $display("NAND ~(a & b): %16b", out[5]);
        $display("NOT a: %16b", out[1]);
        $display("NOT b: %16b", out[2]);
        $display("OR a | b: %16b", out[3]);
        $display("NOR ~(a | b): %16b", out[4]);
        $display("XOR a ^ b: %16b", out[6]);
        $display("XNOR ~(a ^ b): %16b", out[7]);
        $display("SUB %d - %d = %d", a, b, out[8][0], out[9]);
        //
    end

endmodule

