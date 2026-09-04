////////////////////////////////////////////////////// UART RECEIVER ///////////////////////////////////////////////////

//SIPO SHIFT REGISTER
module SIPO(clk,rx_data,reset,p_out,shift);
input rx_data,reset,clk,shift;
output [7:0]p_out;
reg [7:0]register;

always @(posedge clk or negedge reset)
if(!reset)
register <= 8'bxxxx_xxxx;
else if (shift == 1)
register <= {rx_data,register[7:1]};
else
register <= register;

assign p_out = register;
endmodule

// START DETECTOR 
module start_detector(bit_recieved,start_detect);
input bit_recieved;
output reg start_detect;

always @(bit_recieved) 
if(bit_recieved == 0) begin
start_detect = 1; 
end
else  begin
start_detect = 0;
end
endmodule

//PARITY CHECKER
module parity_checker(data_rx,parity_bit_rx,parity_error,parity_load);
input [7:0]data_rx;
input parity_bit_rx,parity_load;
output reg parity_error;

always @(*)
if(parity_load) begin
if(parity_bit_rx == ^data_rx)
parity_error = 0;
else
parity_error = 1; end
endmodule

//STOP CHECKER
module stop_checker(stop_bit_rx,stop_bit_error,stop_bit_check);
input stop_bit_rx,stop_bit_check;
output reg stop_bit_error;

always @(stop_bit_rx,stop_bit_check)
if(stop_bit_check == 1) begin
if(stop_bit_rx == 1)
stop_bit_error = 0;
else
stop_bit_error = 1; end
endmodule

// UART Rx FSM
module uart_rx_fsm(reset,rx_shift,stop_bit_check,clk,parity_load,parity_error,start_detect);
input reset,clk,parity_error,start_detect;
output reg rx_shift,stop_bit_check,parity_load;

reg [1:0] state,next_state;
integer count = 1;
reg count_start;

parameter idle = 2'b00, data_bit = 2'b01, parity_bit = 2'b10, stop_bit = 2'b11;
always @(start_detect,state,count,parity_error)
begin
case(state)
idle:       next_state = (start_detect == 1) ? data_bit:idle;
data_bit: begin 
count_start = (count == 8)?0:1;
next_state = (count == 8)?parity_bit:data_bit;
end
//parity_bit: begin next_state = stop_bit; end
parity_bit: next_state = (parity_error == 1)?idle:stop_bit;
stop_bit: next_state = idle;
//default: next_state = idle;
endcase
end

always @(posedge clk,negedge reset)
if(!reset)
state <= idle;
else
state <= next_state;

always @(posedge clk)
if(count_start)
count <= count + 1;
else
count <= 1;

always @(state)
begin
if(state == idle) begin
stop_bit_check = 0; parity_load = 0; rx_shift = 0; end

else if(state == data_bit) begin
stop_bit_check = 0; parity_load = 0; rx_shift = 1; end

else if(state == parity_bit) begin
stop_bit_check = 0; parity_load = 1; rx_shift = 0; end

else if(state == stop_bit) begin
stop_bit_check = 1; parity_load = 0; rx_shift = 0; end

else begin
stop_bit_check = 0; parity_load = 0; rx_shift = 0; end

end
endmodule


//////////////////////////// TOP MODULE UART_RECEIVER ///////////////////////////////
module uart_receiver(reset,clk,rx_data,parity_error,rx_data_out,stop_bit_error);
input reset,clk,rx_data;
output parity_error,stop_bit_error;
output [7:0]rx_data_out;
wire rx_shift,stop_bit_check,parity_load,start_detect;
wire [7:0]data_received;

uart_rx_fsm rfsm(reset,rx_shift,stop_bit_check,clk,parity_load,parity_error,start_detect);
stop_checker sc(rx_data,stop_bit_error,stop_bit_check);
parity_checker pc(data_received,rx_data,parity_error,parity_load);
start_detector sd(rx_data,start_detect);
SIPO sipo1(clk,rx_data,reset,data_received,rx_shift);

assign rx_data_out = (!stop_bit_error)?data_received:8'bx;

endmodule