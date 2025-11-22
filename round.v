/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module round( output wire [ 31 : 0 ] rl,
              output wire [ 31 : 0 ] rr,
               input wire [ 31 : 0 ] xl,
               input wire [ 31 : 0 ] xr,
               input wire [ 47 : 0 ] k );

  // Stage 1: complete this module implementation
  wire [47:0]perm_r;
  wire [47:0]xor_k;
  wire [5:0]x0;
  wire [5:0]x1;
  wire [5:0]x2;
  wire [5:0]x3;
  wire [5:0]x4;
  wire [5:0]x5;
  wire [5:0]x6;
  wire [5:0]x7;
  
  wire [3:0]r0;
  wire [3:0]r1;
  wire [3:0]r2;
  wire [3:0]r3;
  wire [3:0]r4;
  wire [3:0]r5;
  wire [3:0]r6;
  wire [3:0]r7;
  
  wire [31:0]merged;
  wire [31:0]permed;
  
  
  perm_E t0(.x(xr), .r(perm_r));
  assign xor_k = perm_r ^ k;
  split_1 t1(.x(xor_k),.r0(x0),.r1(x1),.r2(x2),.r3(x3),.r4(x4),.r5(x5),.r6(x6),.r7(x7));
  
  sbox_0 t2(.x(x0),.r(r0));
  sbox_1 t3(.x(x1),.r(r1));
  sbox_2 t4(.x(x2),.r(r2));
  sbox_3 t5(.x(x3),.r(r3));
  sbox_4 t6(.x(x4),.r(r4));
  sbox_5 t7(.x(x5),.r(r5));
  sbox_6 t8(.x(x6),.r(r6));
  sbox_7 t9(.x(x7),.r(r7));
  
  merge_1 t10(.x0(r0),.x1(r1),.x2(r2),.x3(r3),.x4(r4),.x5(r5),.x6(r6),.x7(r7),.r(merged));
  perm_P t11(.x(merged),.r(permed));
  assign rr = permed ^ xl;
  assign rl = xr;
  
  
  
  
  
  
  
  
  

endmodule
