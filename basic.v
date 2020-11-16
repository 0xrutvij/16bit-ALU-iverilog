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
*****      MUX2            ********
**********************************/

module MUX2 (out, select, in0, in1);
    output [15:0] out; wire [15:0] out;
    input select; wire select;
    input [15:0] in0, in1; wire [15:0] in0, in1;

    assign out = select ? in1 : in0; 

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