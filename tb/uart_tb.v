/////// TESTBENCH UART MAIN
module tb_uart_main_baud;
reg reset,tx_start;
reg tx_clk=0;
reg rx_clk = 0;
reg [7:0]rx_data;
reg [1:0]baud_sel;
wire parity_error,stop_bit_error;
wire [7:0]data_output;

uart_main_baud dut_uart(data_output,parity_error,stop_bit_error,reset,tx_clk,rx_clk,tx_start,baud_sel,rx_data);

initial
forever #500 tx_clk = ~tx_clk;
initial
forever #62.5 rx_clk = ~rx_clk;

initial begin
baud_sel = 2'b00;
end

initial begin
reset = 0; tx_start = 0;

#3000 reset = 1;
#40 tx_start = 1;
//#4000 tx_start = 0;
end

initial begin
rx_data = 8'b1010_0101;
end
endmodule 