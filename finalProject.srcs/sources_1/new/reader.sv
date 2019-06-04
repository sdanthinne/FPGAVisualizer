`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sebastien Danthinne
// 
// Create Date: 05/29/2019 12:24:11 AM
// Design Name: 
// Module Name: reader
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//reads data input to vpin and vnin and outputs to data
module data_reader(clk,vpin,vnin, data_out,data_ready);
input clk;
input vpin,vnin;
output [15:0] data_out;
output data_ready;
//logic busy,channel,alarm;
//module xadc_wiz_0
//          (
//          daddr_in,            // Address bus for the dynamic reconfiguration port
//          dclk_in,             // Clock input for the dynamic reconfiguration port
//          den_in,              // Enable Signal for the dynamic reconfiguration port
//          di_in,               // Input data bus for the dynamic reconfiguration port
//          dwe_in,              // Write Enable for the dynamic reconfiguration port
//          busy_out,            // ADC Busy signal
//          channel_out,         // Channel Selection Outputs
//          do_out,              // Output data bus for dynamic reconfiguration port
//          drdy_out,            // Data ready signal for the dynamic reconfiguration port
//          eoc_out,             // End of Conversion Signal
//          eos_out,             // End of Sequence Signal
//          alarm_out,           // OR'ed output of all the Alarms    
//          vp_in,               // Dedicated Analog Input Pair
//          vn_in);
wire w1,eoc,eos;
//logic [15:0] truncate;

xadc_wiz_0 xadc( 
    .daddr_in(8'h16),
    .dclk_in(clk),
    .den_in(eoc),
    .di_in(),
    .dwe_in(),
    .busy_out(),
    .channel_out(),
    .do_out(data_out),
    .drdy_out(data_ready),
    .eoc_out(eoc),
    .eos_out(eos),
    .alarm_out(),
    .vp_in(),
    .vn_in(),
    .vauxp6(vpin),
    .vauxn6(vnin)
    );
//assign data_out = truncate[15:4];



endmodule
