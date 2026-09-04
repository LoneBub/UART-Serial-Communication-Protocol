///////////////////////////////////////// BAUD RATE GENERATOR //////////////////////////////////////////////////////
// BAUD RATE TRANSMITTER 
module baud_gen_tx(baud_sel,baud_out,clk);
input [1:0]baud_sel;
input clk;
output reg baud_out;
wire baud_115200bps,baud_38400bps,baud_19200bps,baud_9600bps;
integer count1 = 0;
integer count2 = 0;
integer count3 = 0;
integer count4 = 0;

always @(posedge clk)
if(count1<868)
count1 <= count1+1;
else
count1 = 1;
assign baud_115200bps = (count1 < 435) ? 1:0;

always @(posedge clk)
if(count2<16)
count2 <= count2+1;
else
count2 = 1;
assign baud_38400bps = (count2 < 9) ? 1:0;

always @(posedge clk)
if(count3<32)
count3 <= count3+1;
else
count3 = 1;
assign baud_19200bps = (count3 < 17) ? 1:0;

always @(posedge clk)
if(count4<66)
count4 <= count4+1;
else
count4 = 1;
assign baud_9600bps = (count4 < 34) ? 1:0;

always @(baud_sel,baud_115200bps,baud_38400bps,baud_19200bps,baud_9600bps)
begin
case(baud_sel)
2'b00: baud_out = baud_115200bps;
2'b01: baud_out = baud_38400bps;
2'b10: baud_out = baud_19200bps;
2'b11: baud_out = baud_9600bps;
endcase
end
endmodule

//BAUD RATE RECEIVER
module baud_gen_rx(baud_sel,baud_out,clk);
input [1:0]baud_sel;
input clk;
output reg baud_out;
wire baud_115200bps,baud_38400bps,baud_19200bps,baud_9600bps;
integer count1 = 0;
integer count2 = 0;
integer count3 = 0;
integer count4 = 0;

always @(posedge clk)
if(count1<70)
count1 <= count1+1;
else
count1 = 1;
assign baud_115200bps = (count1 < 36) ? 1:0;

always @(posedge clk)
if(count2<208)
count2 <= count2+1;
else
count2 = 1;
assign baud_38400bps = (count2 < 105) ? 1:0;

always @(posedge clk)
if(count3<26)
count3 <= count3+1;
else
count3 = 1;
assign baud_19200bps = (count3 < 14) ? 1:0;

always @(posedge clk)
if(count4<52)
count4 <= count4+1;
else
count4 = 1;
assign baud_9600bps = (count4 < 27) ? 1:0;

always @(baud_sel,baud_115200bps,baud_38400bps,baud_19200bps,baud_9600bps)
begin
case(baud_sel)
2'b00: baud_out = baud_115200bps;
2'b01: baud_out = baud_38400bps;
2'b10: baud_out = baud_19200bps;
2'b11: baud_out = baud_9600bps;

// default: baud_out = 1'bx;
endcase
end
endmodule