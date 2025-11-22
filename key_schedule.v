/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module key_schedule( output wire [ 55 : 0 ] r,
                     output wire [ 47 : 0 ] k,
                      input wire [ 55 : 0 ] x,
                      input wire [  3 : 0 ] i );

  // Stage 1: complete this module implementation
  wire [27:0]r1;
  wire [27:0]r0;
  wire [27:0]clr_l;
  wire [27:0]clr_r;
  wire [55:0]merged;
  
  split_0 t0(.x(x), .r1(r1), .r0(r0));
  clr_28bit t1(.x(r1),.r(clr_l),.y(i));
  clr_28bit t2(.x(r0),.r(clr_r),.y(i));
  merge_0 t3(.x1(clr_l),.x0(clr_r),.r(merged));
  assign r = merged;
  perm_PC2 t4(.x(merged), .r(k));
  

endmodule
