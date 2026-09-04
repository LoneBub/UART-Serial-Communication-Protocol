//////////////////////////////////////// UART TRANSMITTER ///////////////////////////////////////////////////
// parity generator
module parity_generator(data_in,load,parity_bit);
input [7:0]data_in;
input load;
output parity_bit;
reg [7:0]data_register;

always @(load,data_in)
if(load)
data_register = data_in;
else
data_register = data_register;

assign parity_bit = ^data_register;
endmodule

// mux
module txmux(sel,data_bit_in,parity_bit_in,out);
input [1:0]sel;
input data_bit_in,parity_bit_in;
output reg out;
always @(sel,data_bit_in,parity_bit_in)
case(sel)
2'b00 : out = 1'b0;
2'b01 : out = data_bit_in;
2'b10 : out = parity_bit_in;
2'b11 : out = 1'b1;
endcase
endmodule

// PISO SHIFT REGISTER
module PISO(data_out,load,shift,clk,reset,data_in);
input load,shift,clk,reset;
input [7:0]data_in;
output data_out;
reg [7:0]data;

always @(posedge clk or negedge reset)
begin
if(!reset)
data <= 8'b0000_0000;
else if(load)
data <= data_in;
else if(shift)
data <= {1'b0,data[7:1]};
else
data <= data;
end
assign data_out = data[0];
endmodule

// UART Tx FSM
module uart_tx_fsm(reset,tx_start,sel,clk,load,shift);
input reset,tx_start,clk;
output reg [1:0]sel;
output reg load,shift;
reg [2:0] state,next_state;
integer count = 1;
reg count_start = 0;

parameter idle = 3'b000,start_bit = 3'b001, data_bit = 3'b010, parity_bit = 3'b011, stop_bit = 3'b100;

always @(tx_start,state,count) begin
case(state)
idle:       next_state = tx_start?start_bit:idle;
start_bit:  next_state = data_bit;
data_bit: begin 
count_start = (count == 8)?0:1;
next_state = (count == 8)?parity_bit:data_bit;
end

parity_bit: next_state = stop_bit;
stop_bit: next_state = idle;
default: next_state = idle;
endcase
end

always @(posedge clk or negedge reset)
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
sel = 2'b11; load = 0; shift = 0; end
else if(state == start_bit) begin
sel = 2'b00; load = 1; shift = 0; end
else if(state == data_bit) begin
sel = 2'b01; load = 0; shift = 1; end
else if(state == parity_bit) begin
sel = 2'b10; load = 1; shift = 0; end
else if(state == stop_bit) begin
sel = 2'b11; load = 0; shift = 0; end
else begin
sel = 2'b11; load = 0; shift = 0; 
end
end
endmodule

//////////////////////////// TOP MODULE UART_TRANSMITTER ///////////////////////////////
module uart_transmitter(reset,tx_start,rx_data,clk,out);
input [7:0]rx_data;
input clk,reset,tx_start;
output out;
wire d_out,parity_bit,load,shift;
wire [1:0] sel;

uart_tx_fsm fsm(reset,tx_start,sel,clk,load,shift);
PISO piso1(d_out,load,shift,clk,reset,rx_data);
txmux mux1(sel,d_out,parity_bit,out);
parity_generator pg1(rx_data,load,parity_bit);

endmodule 

// TESTBENCH UART_TRANSMITTER
module tb_uart_transmitter;
reg [7:0]rx_data;
reg clk,reset,tx_start;
wire out;

uart_transmitter dut(reset,tx_start,rx_data,clk,out);

initial
forever #5 clk = ~clk;

initial begin
reset = 0; clk = 0; tx_start = 0;
#2 reset = 1;
end

initial
begin
rx_data = 8'b10011001;
#7 tx_start = 1;
#30 tx_start = 0;
end
endmodule