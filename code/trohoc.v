// Khalid Dakak
// Anindita Palit
// Emory Blair
// Rutvij Shah
// Ryan Radloff

`include "circuit_components.v"


/**********************************
*****      BREADBOARD       *******
**********************************/
module breadboard(a_in, b_in, opcode, clk, a, b, final_output, prev_output, select, error);
    input [15:0] a_in, b_in;
    input [3:0] opcode;
    input clk;
    output [15:0] a, b, final_output, prev_output;
    wire [15:0] a, b, final_output, prev_output;
    output [3:0] select;
    wire [3:0] select;
    output error;

    /*Internal interfaces*/
    wire [15:0] mode = {16{opcode[3]}};
    wire [15:0] [15:0] out, error_mat;
    wire [15:0] errorline;
    wire reset = &select;
    wire never_reset = 0;

    /*Registers*/ 
    REG4 selector (opcode, select, clk, reset);
    REG16 a_reg (a_in, a, clk, reset);
    REG16 b_reg (b_in, b, clk, reset);
    REG16 pers_op(final_output, prev_output, clk, reset); //Persistent output (stores prev output)

    /*Modules ordered by Opcode*/

    /* 0000     No Op */
    assign out[0] = prev_output;
    assign error_mat[0][0] = 0;
    /* 0001    AND */
    bit16_and and_test(out[1], a, b);
    assign error_mat[1][0] = 0;
    /* 0010    OR */
    bit16_or or_test(out[2], a, b);
    assign error_mat[2][0] = 0;
    /* 0011    XOR */
    bit16_xor xor_test(out[3], a, b);
    assign error_mat[3][0] = 0;
    /* 0100    ADD */
    bit16_adder adder_test(a, b, mode, error_mat[4][0], out[4]);
    /* 0101    MULTIPLY */
    multiplier_16bit mult_test(a, b, out[5], error_mat[5][0]);
    /*  0110    Shift Right */
    shiftRight srl_test(out[6], a, b[3:0]);
    assign error_mat[6][0] = 0;
    /* 0111    NOT */
    bit16_not not_t1(out[7], a);
    assign error_mat[7][0] = 0;
    /* 1000    MOD */
    modulus_16bit mod_test(a, b, out[8], error_mat[8][0]);
    /* 1001    NAND */
    bit16_nand nand_test(out[9], a, b);
    assign error_mat[9][0] = 0;
    /* 1010    NOR */
    bit16_nor nor_test(out[10], a, b);
    assign error_mat[10][0] = 0;
    /* 1011    XNOR */
    bit16_xnor xnor_test(out[11], a, b);
    assign error_mat[11][0] = 0;
    /* 1100    SUBRACT */
    assign out[12] = out[4];
    assign error_mat[12][0] = error_mat[4][0];
    /* 1101    DIVIDE */
    divider_16bit    div_test(a, b, out[13], error_mat[13][0]);
    /* 1110    Shift Left */
    shiftLeft sll_test(out[14], a, b[3:0]);
    assign error_mat[14][0] = 0;
    /* 1111    Reset */
    assign out[15] = 0;
    assign error_mat[15][0] = 0;

    /* MUXers */
    MUX16   mux_output_select(out, select, final_output);
    MUX16   error_state(error_mat, select, errorline);

    /**/
    assign error = errorline[0];
    

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
    wire [15:0] final_output;
    wire [15:0] prev_output;
    wire  error;

    breadboard bb8 (a_in, b_in, opcode, clk, a, b, final_output, prev_output, select, error);
    reg [8*9:1] string;

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

    //Display Thread
    initial begin
            $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+---+");
            $display("|Input A|    A Binary    |Input B|    B Binary    |Operation|Op Binary|Opcode|Output|    O Binary    |Error| TM|");
            i = 7;
            #7;
        forever 
        begin
            $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+---+");
            $display("|%7d|%16b|%7d|%16b|%9s|%9b|%6d|%6d|%16b|    %1b|%3d|",
                    a, a, b, b, string, select, select, final_output, final_output, error, i);
            if (i%100 == 7 && i != 7) 
            begin
                $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+---+");
                $display("|Input A|    A Binary    |Input B|    B Binary    |Operation|Op Binary|Opcode|Output|    O Binary    |Error| TM|");
            end
            i = i + 10;
            #10;
        end
    end

    //Stimulous + Display Thread
    initial begin
        string = "   AND   ";
        a_in = 'b001;b_in = 'b001;opcode = 1;
        #10;
        string = "   OR    ";
        a_in = 'b1001;b_in = 'b0110;opcode = 2;
        #10;
        string = "   XOR   ";
        a_in = 'b1111;b_in = 'b1001;opcode = 3;
        #10;
        string = "  NO-OP  ";
        opcode = 0;
        #10;
        string = "   ADD   ";
        a_in = 355;b_in = 5;opcode = 4;
        #10;
        string = "   ADD   ";
        a_in = 50000;b_in = 50000;opcode = 4;
        #10;
        string = "  RESET  ";
        opcode = 15;
        #10;
        a_in = 25;b_in = 25;opcode = 5;
        string = " MULTIPLY";
        #10;
        string = " MULTIPLY";
        a_in = 2500;b_in = 2500;opcode = 5;
        #10;
        string = "  RESET  ";
        opcode = 15;
        #10;
        string = "  NO-OP  ";
        a_in = 0;b_in = 0;opcode = 0;
        #10;
        string = " SHIFT R ";
        a_in = 32;b_in = 4;opcode = 6;
        #10;
        string = "   NOT   ";
        a_in = 0;b_in = 1;opcode = 7;
        #10;
        string = "   MOD   ";
        a_in = 209;b_in = 50;opcode = 8;
        #10;
        string = "  NAND   ";
        a_in = 'b001;b_in = 'b001;opcode = 9;
        #10;
        string = "   NOR   ";
        a_in = 'b001;b_in = 'b001;opcode = 10;
        #10;
        string = "  XNOR   ";
        a_in = 'b001;b_in = 'b001;opcode = 11;
        #10;
        string = " SUBTRACT";
        a_in = 30000;b_in = 25000;opcode = 12;
        #10;
        string = "  DIVIDE ";
        a_in = 9801;b_in = 121;opcode = 13;
        #10;
        string = " SHIFT L ";
        a_in = 1;b_in = 15;opcode = 14;
        #10;
        $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+---+");
        $finish();
    end

endmodule


/*
Things left to do:
Noop => DONE
Clear => DONE
SL & SR => DONE
Modulus
*/




