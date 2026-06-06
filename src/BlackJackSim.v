module BlackJackSim(
	input clk_50,
	input [9:0] SW,
	input [1:0] KEY,
	output [6:0] HEX5, HEX4, 
	output [6:0] HEX3, HEX2,
	output [6:0] HEX1, HEX0,
	output reg [9:0] LEDR
);
	
	wire clk_5;
   ClockDivider div(.cin(clk_50), .cout(clk_5));
	
   reg [6:0] player_total = 0;
	reg [6:0] dealer_total = 0;

   // Randomizer
   reg [7:0] rand = 1;
   always @(posedge clk_50)
       rand <= {rand[6:0], rand[7]^rand[5]^rand[4]^rand[3]};
   wire [3:0] card = (rand[3:0] % 10) + 1;   // 1..10
	
	reg stand = 0;
	reg compare = 0;
	reg bust = 0; //bust flag
	
	// Apparently I need this because of the board's 50MHz thing or whatever. If I dont have this the player hits and a ton of cards will be added, leading to bust
   reg k0_prev = 1, k1_prev = 1;
   always @(posedge clk_50) begin
       k0_prev <= KEY[0];
       k1_prev <= KEY[1];
		  
		 //stand 
       if (k0_prev == 1 && KEY[0] == 0 && !bust) begin
			  stand <= 1;
			  
           //player_total <= 0;
		//hit
       end else if (k1_prev == 1 && KEY[1] == 0 && !stand && !bust) begin
           if (player_total + card> 21) begin
               //if a player "busts", show the total and "Lose"
					player_total <= player_total + card; //keep bust total
					compare <= 1; //triggers result stage
					bust <= 1; //mark that the player busts
			  end else begin
               player_total <= player_total + card;   // add one "card"
			  end
		 end
   end
	
	reg [3:0] win = 0; 
	reg [3:0] win2 = 0;
	
	reg dealer_done = 0;
	reg player_win = 2; //defualt/neutral
	reg reset_game = 0;
	
	//dealer logic 
	always @(posedge clk_5) begin
		//if the player busts, skip the dealer logic
		if(compare && (player_total > 21)) begin
			win <= 3; //show L
			win2 <= 0;
			dealer_done <= 1;
		end else if (stand && !dealer_done) begin
				// Dealer's turn: keep hitting until 17 or more
				if (dealer_total < 17) begin
            dealer_total <= dealer_total + card;
				end else begin
						// Dealer has finished hitting
						dealer_done <= 1;

						// Now do the comparison ONCE
						if (player_total > dealer_total) begin
							win  <= 1; 
							win2 <= 2;   // player wins
							player_win <= 1;
						end else if (player_total < dealer_total) begin
							win  <= 3;   // dealer wins
							win2 <= 0;   // or leave as-is if you don’t care
							player_win <= 0;
						end else begin
							win  <= 4; 
							win2 <= 5;   // tie
							player_win <= 2;
						end

				end
			end
			// If stand == 0, or dealer_done == 1, do nothing here
		end
	
	//LED LOGIC
	reg led_phase = 0; //toggles even/odd lights for player win
	// set leds to off by default
	always @(posedge clk_5) begin
		if(player_win == 1) begin
			//toggle phase each clk_5 cycle
			led_phase <= ~led_phase;
			if(led_phase) begin
				//turn odd LEDS
				LEDR <= 10'b1010101010; // LEDs 9,7,5,3,1
			end else begin
				//even LEDS
				LEDR <= 10'b0101010101; // LEDs 8,6,4,2,0
			end
		end else if(player_win == 0) begin
			//solid if dealer wins
			LEDR <= 10'b1111111111;
		end else if(player_win == 2) begin
			//tie game or if game is not finished, everything stays off
			LEDR <= 10'b0000000000;
		end
	end
				
	
	SevenSegRes win_tens(.digit(win), .outs(HEX1));
	SevenSegRes win_ones(.digit(win2), .outs(HEX0));
	

   wire [3:0] tens = player_total / 10;
   wire [3:0] ones = player_total % 10;

   SevenSegDecimal player_tens(.result(tens), .display(HEX3));
   SevenSegDecimal player_ones(.result(ones), .display(HEX2));
	
	wire [3:0] dtens = dealer_total / 10;
	wire [3:0] dones = dealer_total % 10;
	
	SevenSegDecimal dealer_tens(.result(dtens), .display(HEX5));
   SevenSegDecimal dealer_ones(.result(dones), .display(HEX4));
	
	

endmodule


module ClockDivider(cin,cout);

// Based on code from fpga4student.com
// cin is the input clock; if from the DE10-Lite,
// the input clock will be at 50 MHz
// The clock divider toggles cout every 25 million cycles of the input clock

input cin;
output reg cout;

reg[31:0] count; 
parameter D = 32'd25000000;

always @(posedge cin)
begin
   count <= count + 32'd1;
      if (count >= (D-1)) begin
         cout <= ~cout;
         count <= 32'd0;
      end
end


endmodule



module SevenSegDecimal(result, display);

	input [3:0] result;
	output reg [6:0] display;
	
	always@(result)
		begin
			case(result)
				4'b0000: display = 7'b1000000;
				4'b0001: display = 7'b1111001;
				4'b0010: display = 7'b0100100;
				4'b0011: display = 7'b0110000;
				4'b0100: display = 7'b0011001;
				4'b0101: display = 7'b0010010;
				4'b0110: display = 7'b0000010;
				4'b0111: display = 7'b1111000;
				4'b1000: display = 7'b0000000;
				4'b1001: display = 7'b0010000;
				4'b1010: display = 7'b0001000;
				4'b1011: display = 7'b0000011;	
				4'b1100: display = 7'b1000110;
			
				default: display = 7'b1111111;
			endcase
		end

endmodule

module SevenSegRes(digit, outs);

	input [3:0] digit;
	output reg [6:0] outs;
	
	always@(digit)
		begin
			case(digit)
				4'b0001: outs = 7'b1000001; 
				4'b0010: outs = 7'b1110001; 
				
				4'b0011: outs = 7'b1000111;
				
				4'b0100: outs = 7'b1111000;
				4'b0101: outs = 7'b1001110;
				
				default: outs = 7'b1111111;
			endcase
		end

endmodule