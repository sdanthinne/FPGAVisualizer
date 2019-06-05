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


//module connector(clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,vpin,vnin);
//input clk,vpin,vnin;
//output [3:0] vgaGreen,vgaBlue,vgaRed;
//output Hsync,Vsync;
//logic [11:0] data_out;
//logic ready; 
//data_reader d1 (clk, vpin,vnin,data_out,ready);
//vgaTop vga1 (.clk(clk),.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.Hsync(Hsync),.Vsync(Vsync),.sw(data_out));

//endmodule


module finalFSM(clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,vpin,vnin,btnC);
input clk,vpin,vnin,btnC;
//input [15:0] sw;
//output [15:0] led;
output [3:0] vgaRed, vgaGreen, vgaBlue;
output Hsync,Vsync;
logic ready;
logic [11:0] data_out;
logic [11:0] data_out_mem;
logic [11:0] data_div;
logic [11:0] disp_out;
logic [9:0] x,y;
typedef enum logic[1:0]  {A,B,C,D} state;
state cs,ns;

data_reader d1 (clk, vpin,vnin,data_out,ready);
//sw is the color bus, with 12 bits. 4 bits per RGB color
vgaTop vga1 (.clk(clk),.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.Hsync(Hsync),.Vsync(Vsync),.sw(disp_out),.x(x),.y(y));




initial begin
    cs = B;
end

always_ff @ (posedge clk)
begin
cs <= ns;
end

always_comb
begin
    case(cs)
        A:
        begin
        //display what is in the memory
        // needs to calculate rectangle width
        //divide the data in by 100
        //display some color
            data_div = data_out_mem/100;
            ns = B;
            if(x<data_out_mem)
            begin
            disp_out = 12'b100010100100;
            end
            else
            begin
            disp_out = 12'd0;
            end
            
            
        end
        
        B:begin
        //load what is read from the ADC to memory
            if(~btnC)begin
            //if the enable button is not pressed, go back to display
                ns = A;
            end
            else
            begin
            //if the enable button is pressed, do calculation
                ns = C;
            end
            data_out_mem=data_out;
        end

//does some sort of computation here for these opcode-enabled states
        C:begin
        //compute calculation, store, and route back to display
            ns = A;
        end

    endcase
end

always_comb
begin
    
end






endmodule