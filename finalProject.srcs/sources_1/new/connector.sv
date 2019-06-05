`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sebastien Danthinne
// 
// Create Date: 06/04/2019 10:13:59 PM
// Design Name: 
// Module Name: connector
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


module connector(clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,vpin,vnin);
input clk,vpin,vnin;
output [3:0] vgaGreen,vgaBlue,vgaRed;
output Hsync,Vsync;
logic [11:0] data_out;
logic ready; 
data_reader d1 (clk, vpin,vnin,data_out,ready);
vgaTop vga1 (.clk(clk),.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.Hsync(Hsync),.Vsync(Vsync),.sw(data_out));

endmodule
