/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module encrypt_iter(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message

                      input wire                  clk,   //  input control:       clock signal
                      input wire                  rst,   //  input control:       reset signal
                      input wire                  req,   //  input control:     request signal
                     output wire                  ack ); // output control: acknowledge signal

  // Stage 3: complete this module implementation
  // define each state using one hot encoding:
  parameter [3:0]IDLE =4'b0001;
  parameter [3:0]LOAD =4'b0010;
  parameter [3:0]RUN =4'b0100;
  parameter [3:0]DONE =4'b1000;
  
  // define registers to hold the current and next state for later computation:
  reg [4:0]current;
  reg [4:0]next;
  reg ack_r;
  // registers to hold intermediate results of each round and counter
  reg [31:0]round_l_result;
  reg [31:0]round_r_result;
  reg [55:0]key_result;
  reg [3:0]counter;
 
 // wires to hold temporary results between each round
  wire [31:0]round_l;
  wire [31:0]round_r;
  wire [47:0]sub_key;
  wire [55:0]key;
  
  // pre processing wires:
  wire [55:0]perm_pc1_out;
  wire [63:0]perm_ip_out;
  wire [31:0]split_l;
  wire [31:0]split_r;
  
  //post processing wire and reg
  reg [31:0]merge_in_l;
  reg [31:0]merge_in_r;
  wire [63:0]merge_result;
  
  
  
  
  //pre processing
  perm_PC1 t0(.x(k),.r(perm_pc1_out));
  perm_IP t1(.x(m),.r(perm_ip_out));
  split_2 t3(.x(perm_ip_out),.r1(split_l),.r0(split_r));
  
  
  
  
  
  // defines which state to go depending on condition if any and current state
  always @(*) begin
  	next = current;
  	ack_r = 1'b0;
  	
  	case (current) 
  		IDLE:begin // if req is 1 then it means data ready to load so move to LOAD state
  			if (req) begin
  				next = LOAD;
  			end
  		end
  		LOAD:begin // once in LOAD after loads initial data from pre processing it goes to RUN to start the computation
  			next = RUN;
  		end
  		RUN:begin // if counter is 15 then at the last round so move to DONE state if not stay in RUN
  			if (counter == 4'd15) begin
  				next = DONE;
  			end
  		end
  		
  		DONE:begin // if in DONE change ACK to 1 allows user to notice change that computation is over
  			ack_r = 1'b1;
  			if (!req) begin
  				next = IDLE;
  			end
  		end
  		default:begin
  			next = IDLE;
  		end
  	endcase
  end
  assign ack = ack_r;
  // defines what happens to data at each state- does this at a positive edge of the clk signal, or resets the data if rst has a positive edge:
  always @(posedge clk or posedge rst) begin
  	if (rst) begin
  		current <= IDLE;
  		counter <= 4'd0;
  		round_l_result <= 32'd0;
  		round_r_result <= 32'd0;
  		key_result <= 56'd0;
  	end else begin
  		current <= next; // so we stay in current 
  		case (current) 
  			LOAD:begin
  				key_result <= perm_pc1_out;
  				round_l_result <= split_l;
  				round_r_result <= split_r;
  				
  			end
  			RUN:begin
  				round_l_result <= round_l; // set next round input to current round output
  				round_r_result<=round_r;
  				key_result<=key;
  				counter <= counter+ 4'd1; // update to next round
  			end
  			
  			default:begin
  			end
  		endcase
  	end
  end
  
  // processing
  
  key_schedule t4(.x(key_result),.r(key),.k(sub_key),.i(counter));
  round t5(.xl(round_l_result),.xr(round_r_result),.rl(round_l),.rr(round_r),.k(sub_key));
  
  //post processing
  
  merge_2 t6(.x1(round_r_result),.x0(round_l_result),.r(merge_result));
  perm_FP t7(.x(merge_result),.r(c));
  
  			
  
  	
  
  
  
  
  

endmodule
