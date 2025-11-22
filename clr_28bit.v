/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module clr_28bit( output wire [ 27 : 0 ] r,
                   input wire [ 27 : 0 ] x,
                   input wire [  3 : 0 ] y );

  // Stage 1: complete this module implementation
  wire fy;
  assign fy = (y[3]&y[2]&y[1]&y[0])| (~y[3]&~y[2]&~y[1]&~y[0])|(y[3]&~y[2]&~y[1]&~y[0])|(~y[3]&~y[2]&~y[1]&y[0]);
  assign r = fy ? {(x<<1) | (x >> 27)} : {(x<<2) | (x>>26)};

endmodule
