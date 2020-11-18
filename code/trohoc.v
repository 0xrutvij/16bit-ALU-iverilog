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
    REG4 selector (opcode, select, clk, never_reset);
    REG16 a_reg (a_in, a, clk, reset);
    REG16 b_reg (b_in, b, clk, reset);
    REG16 pers_op(final_output, prev_output, clk, reset); //Persistent output (stores prev output)

    /*Modules ordered by Opcode*/

    /* 0000     No Op */
    assign out[0] = prev_output;
    /* 0001    AND */
    bit16_and and_test(out[1], a, b);
    /* 0010    OR */
    bit16_or or_test(out[2], a, b);
    /* 0011    XOR */
    bit16_xor xor_test(out[3], a, b);
    /* 0100    ADD */
    bit16_adder adder_test(a, b, mode, error_mat[4][0], out[4]);
    /* 0101    MULTIPLY */
    multiplier_16bit mult_test(a, b, out[5], error_mat[5][0]);
    /*  0110    Shift Right */
    shiftRight srl_test(out[6], a, b[3:0]);
    /* 0111    NOT */
    bit16_not not_t1(out[7], a);
    /* 1000    MOD */
    modulus_16bit mod_test(a, b, out[8], error_mat[8][0]);
    /* 1001    NAND */
    bit16_nand nand_test(out[9], a, b);
    /* 1010    NOR */
    bit16_nor nor_test(out[10], a, b);
    /* 1011    XNOR */
    bit16_xnor xnor_test(out[11], a, b);
    /* 1100    SUBRACT */
    assign out[12] = out[4];
    assign error_mat[12][0] = error_mat[4][0];
    /* 1101    DIVIDE */
    divider_16bit    div_test(a, b, out[13], error_mat[13][0]);
    /* 1110    Shift Left */
    shiftLeft sll_test(out[14], a, b[3:0]);
    /* 1111    Reset */
    assign out[15] = 0;

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
    //string ops[int];
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
         /*ops = '{ "  RESET  " : 0,
                     "   AND   " : 1,
                     "   OR    " : 2,
                     "   XOR   " : 3,
                     "   ADD   " : 4,
                     " MULTIPLY" : 5,
                     " SHIFT R " : 6,
                     "   NOT   " : 7,
                     "   MOD   " : 8,
                     "  NAND   " : 9,
                     "   NOR   " : 10,
                     "   XNOR  " : 11,
                     " SUBTRACT" : 12,
                     "  DIVIDE " : 13,
                     " SHIFT L " : 14,
                     "  RESET  " : 15
                    };
                    */
            $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+--+");
            $display("|Input A|A Binary        |Input B|B Binary        |Operation|Op Binary|Opcode|Output|O Binary        |Error|TM|");
            i = 0;
            //#6;
        forever 
        begin
            $display("+-------+----------------+-------+----------------+---------+---------+------+------+----------------+-----+--+");
            $display("|%7d|%16b|%7d|%16b|%9s|%9b|%6d|%6d|%16b|    %1b|%2d|",
                    a, a, b, b, string, opcode, opcode, final_output, final_output, error, i);
            i = i + 1;
            #1;
        end
    end

    //Stimulous + Display Thread
    initial begin
        string = "  DIVIDE ";
        a_in = 40000;b_in = 5;opcode = 13;
        #15;
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




