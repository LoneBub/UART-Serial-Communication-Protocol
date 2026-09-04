////////////////////////////////////// UART MAIN MODULE (WITH BAUD RATE) //////////////////////////////////////////
module uart_main_baud(data_output,parity_error,stop_bit_error,reset,tx_clk,rx_clk,tx_start,baud_sel,rx_data);
input reset,tx_clk,rx_clk,tx_start;
input [7:0]rx_data;
input [1:0]baud_sel;
output parity_error,stop_bit_error;
output [7:0]data_output;
wire tx_rx_wire;
wire baud_out_tx,baud_out_rx;

uart_transmitter tx1(reset,tx_start,rx_data,baud_out_tx,tx_rx_wire);
uart_receiver rx1(reset,baud_out_rx,tx_rx_wire,parity_error,data_output,stop_bit_error);
baud_gen_tx baudtx(baud_sel,baud_out_tx,tx_clk);
baud_gen_rx baudrx(baud_sel,baud_out_rx,tx_clk);

endmodule