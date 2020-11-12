// Khalid Dakak
// Anindita Palit
// Emory Blair
// Rutvij Shah
// Ryan Radloff

/**********************************
*****      DFF            *********
**********************************/
module DFF(clk, in, out, reset);
    input clk;
    input in;
    input reset;
    output out;
    reg out;
    
    always @(posedge clk or posedge reset)
    if (reset) begin
        out = 0;
    end
    else begin
        out = in;
    end
endmodule

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
*****      MUX16           ********
**********************************/
module MUX16(channels, select, b);
    input [15:0][15:0] channels;
    input [3:0] select;

    output [15:0] b;

    assign b = channels[select];
endmodule


/**********************************
*****      MUX4            ********
**********************************/
module MUX4(channels, select, b);
    input [3:0] channels;
    input [1:0] select;

    output b;

    assign b = channels[select];
endmodule

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
******* Half-Adder ***********
****************************/

module add_half (input a, b, output c_out, sum);

    xor g1(sum, a, b);
    and g2(c_out, a, b);

endmodule

/***************************
******* Full-Adder ***********
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
*****      MUX2            ********
**********************************/

module MUX2 (out, select, in0, in1);
    output [15:0] out; wire [15:0] out;
    input select; wire select;
    input [15:0] in0, in1; wire [15:0] in0, in1;

    assign out = select ? in1 : in0; 

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


/**********************************
*****      TESTBENCH       ********
**********************************/

// Test Bench //
module testbench();

    integer i;

    reg [3:0] opcode;
    reg [15:0] a_in, b_in;
    wire [15:0] a, b;
    wire [3:0] select;
    reg clk;
    reg [16:0] over;

    wire [15:0] errorline;
    wire [15:0] final_output;
    wire [15:0] pop;
    
    wire [15:0] [15:0] out;
    wire [15:0] [15:0] error;

    reg [15:0]mode;
    bit16_and and_test(out[0], a, b);
    bit16_nand nand_test(out[5], a, b);
    bit16_not not_t1(out[1], a),
              not_t2(out[2], b);
    bit16_or or_test(out[3], a, b);
    bit16_nor nor_test(out[4], a, b);
    bit16_xor xor_test(out[6], a, b);
    bit16_xnor xnor_test(out[7], a, b);
    bit16_adder adder_test(a, b, mode[15:0], error[8][0], out[8]);

    //behavioral components
    multiplier_16bit mult_test(a, b, out[9], error[9][0]);
    divider_16bit    div_test(a, b, out[10], error[10][0]);

    //shift right
    shiftRight srl_test(out[12], a, b[3:0]);
    shiftLeft sll_test(out[13], a, b[3:0]);

    //Reset is 1111 = 15
    wire reset = &select;
    wire never_reset = 0;
    assign out[15] = 0;

    //Noop will be 0000 , for now it is 11
    assign out[11] = pop;

    //MUXers
    MUX16   mux_output_select(out, select, final_output);
    MUX16   error_state(error, select, errorline);

    //DFF selector[3:0] (clk, opcode, select);
    //DFF a_reg[15:0] (clk, a_in, a);
    //DFF b_reg[15:0] (clk, b_in, b);
    
    REG4 selector (opcode, select, clk, never_reset);
    REG16 a_reg (a_in, a, clk, reset);
    REG16 b_reg (b_in, b, clk, reset);
    REG16 pers_op(final_output, pop, clk, reset); //Persistent output (stores prev output)

    //Clock Thread
    initial begin
        forever
        begin
            clk = 0;
            #5;
            clk = 1;
            #5;
        end
    end

    //Stimulous + Display Thread
    initial begin
        mode = 0;
        //a_in = 'b0101001011001001; // 21193
        //b_in = 'b0000110100111110; // 3390
        a_in = 40000;
        b_in = 5;
        opcode = 10;
        $display("DIV %d / %d = %d", a, b, pop);
        $display("Error = %d", errorline[0]);
        #6;
        //posedge
        $display("------------------------------------------------------");
        $display("DIV %d / %d = %d", a, b, final_output);
        $display("Error = %d", errorline[0]);
        opcode = 11;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        opcode = 15;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        opcode = 11;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        opcode = 9;
        a_in = 200;
        b_in = 1000;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        $display("Error = %d", errorline[0]);
        opcode = 12;
        a_in = 32;
        b_in = 5;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        $display("Error = %d", errorline[0]);
        opcode = 13;
        a_in = 2;
        b_in = 4;
        #10;
        //posedge
        $display("------------------------------------------------------");
        $display("a = %d, b = %d, opcode = %d, output = %d", a, b, select, final_output);
        $display("Error = %d", errorline[0]);
        $finish();
    end

endmodule


/*
Things left to do:
Noop
Clear
SL & SR
Modulus
*/





