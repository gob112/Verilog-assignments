/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module encrypt_comb(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c ); // output    data: ciphertext message

  // Stage 2: complete this module implementation
  wire [55:0]initial_perm_k;
  wire [63:0]perm_ip;
  wire [31:0]split_l;
  wire [31:0]split_r;
  wire [63:0]merge_result;
  perm_PC1 t0(.x(k), .r(initial_perm_k));
  perm_IP t1(.x(m),.r(perm_ip));
  split_2 t2(.x(perm_ip),.r1(split_l),.r0(split_r));
  
  genvar a,j;
  generate 
  	for (a=0; a<=16;a=a+1) begin:g0
  		wire [55:0]key_input;
  		wire [47:0]key_round_in;
  		wire [31:0]round_l;
  		wire [31:0]round_r;
  		wire [3:0]i;
  	end
  endgenerate
  
  assign g0[0].i = 4'd0;
  assign g0[1].i = 4'd1;
  assign g0[2].i = 4'd2;
  assign g0[3].i = 4'd3;
  assign g0[4].i = 4'd4;
  assign g0[5].i = 4'd5;
  assign g0[6].i = 4'd6;
  assign g0[7].i = 4'd7;
  assign g0[8].i = 4'd8;
  assign g0[9].i = 4'd9;
  assign g0[10].i = 4'd10;
  assign g0[11].i = 4'd11;
  assign g0[12].i = 4'd12;
  assign g0[13].i = 4'd13;
  assign g0[14].i = 4'd14;
  assign g0[15].i = 4'd15;
  
  assign g0[0].key_input = initial_perm_k;
  assign g0[0].round_l = split_l;
  assign g0[0].round_r = split_r;
  
  
  
  generate
  	for (j=0;j<16;j=j+1) begin:g1
  		key_schedule key_j(.x(g0[j].key_input),.i(g0[j].i),.r(g0[j+1].key_input),.k(g0[j].key_round_in));
  		round round_j(.xl(g0[j].round_l),.xr(g0[j].round_r),.rl(g0[j+1].round_l),.rr(g0[j+1].round_r),.k(g0[j].key_round_in));
  	end
  endgenerate
 
 merge_2 t3(.x1(g0[16].round_r),.x0(g0[16].round_l),.r(merge_result));
 perm_FP t4(.x(merge_result), .r(c));
  
  

endmodule
