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


module finalFSM(clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,vpin,vnin,btnC,sw);
input clk,vpin,vnin,btnC;
input [11:0] sw;
//output [15:0] led;
output [3:0] vgaRed, vgaGreen, vgaBlue;
output Hsync,Vsync;
logic ready,clkd2;
logic [11:0] data_out;
logic [11:0] data_out_mem;
logic [11:0] data_div;
logic [11:0] disp_out;
logic [11:0] data_read;
logic [9:0] x,y;
logic [49:0] cnt;
typedef enum logic[1:0]  {A,B,C,D} state;
state cs,ns;

data_reader d1 (clk, vpin,vnin,data_out,ready);
//sw is the color bus, with 12 bits. 4 bits per RGB color
vgaTop vga1 (.clk(clk),.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.Hsync(Hsync),.Vsync(Vsync),.sw(disp_out),.x(x),.y(y));


 
initial begin
    cs = B;
    clkd2 = 0;
    cnt = 50'd0;
end
//149F95

//okay so the deal with this is that this clock divider should divide to 8*60Hz which is the VGA refresh rate
//this means that the data displayed is only updated every frame
always @(posedge clk)
        {clkd2, cnt} <= cnt + 50'h1421F8107;
        
always_ff @ (posedge clkd2)
begin
data_read <= (data_out)/10;
end

always_comb
begin

//Idea: take samples at 60*(how ever many divisions I want) 
if(x>10&x<data_read&y>10)
    begin
    disp_out = sw;
    end
    else
    begin
    disp_out = 12'd0;
    end



end

//always_ff @ (posedge clkd2)
//begin
//cs <= ns;
//end

//always_comb
//begin
//    case(cs)
//        A:
//        begin
//        //display what is in the memory
//        // needs to calculate rectangle width
//        //divide the data in by 100
//        //display some color
//            data_div = data_out_mem/8;
//            ns = B;
//            if(x<data_div)
//            begin
//            disp_out = sw;
//            end
//            else
//            begin
//            disp_out = 12'd0;
//            end
            
            
//        end
        
//        B:begin
//        //load what is read from the ADC to memory
//            if(~btnC)begin
//            //if the enable button is not pressed, go back to display
//                ns = A;
//            end
//            else
//            begin
//            //if the enable button is pressed, do calculation
//                ns = C;
//            end
//            data_out_mem=data_out;
//        end

////does some sort of computation here for these opcode-enabled states
//        C:begin
//        //compute calculation, store, and route back to display
//            ns = A;
//        end

//    endcase
//end








endmodule