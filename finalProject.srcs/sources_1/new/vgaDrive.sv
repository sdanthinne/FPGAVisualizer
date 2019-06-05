`timescale 1ns/1ps

//author:Sebastien Danthinne

//attempt at a vga driver

//rev: draws some rectangle
//test to see if it works or not
//sw works to make a color
module vgaTop (clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,sw);
    input clk;
    input [11:0] sw;
    output logic [3:0] vgaRed, vgaBlue, vgaGreen;
    output Hsync,Vsync;
    logic [9:0] x,y;
    logic vgaclk,blank;

    vgaClocker vclk (.clk(clk),.vgaclk(vgaclk));
    vgaController vcon (.vgaclk(vgaclk),.hsync(Hsync),.vsync(Vsync),.sync_b(),.blank_b(blank),.x(x),.y(y));
    //assign vgaRed = sw;
    // always @ (negedge vgaclk)
    // begin
         
        
        // if(y%5 == 0)
        // begin
        //     vgaRed = 4'b0000;
        //     vgaGreen = 4'b0000;
        //     vgaBlue = 4'b0000; 
        // end
        // else
        // begin
        //     vgaRed = 4'b0100;
        //     vgaBlue = 4'b0100;
        //     vgaGreen = 4'b0100;
            
//        // end
//   vgaRed = 4'b0000;
//   vgaGreen = 4'b0000;
//   vgaBlue = 4'b0100;
//    end
//    always @ (posedge vgaclk)
//    begin
//         if(y>100 & y< 639)begin
//             vgaRed = 4'd12;
//         end
         
//    end

        always_ff @ (posedge vgaclk)
        begin
        if(blank)
        begin
            vgaRed <= sw[3:0];
            vgaBlue <= sw[7:4];
            vgaGreen <= sw[11:8];
        end
        else
        begin
            vgaRed <= 4'd0;
            vgaBlue <= 4'd0;
            vgaGreen <= 4'd0;
        end
        end
    


endmodule



// this module created a clock with the frequency 25.175MHz
//tested, seems to be creating a clock with freq of 25 MHz, not 25.175.
module vgaClocker  (clk,vgaclk);
    input clk;
    output logic vgaclk;
    logic st_clk;
    reg [15:0] cnt;
    initial begin
        cnt = 16'd0;
        vgaclk = 1'b0;
    end
    
    always @(posedge clk)
        {vgaclk, cnt} <= cnt + 16'h4072;  // divide by 3.9721: (2^16)/3.9721 = 0x4072logic
    // always @(posedge clk)
    //     {st_clk, cnt} <= cnt + 16'h6666;//for 800x600

    
    // always @ (posedge st_clk)
    //     vgaclk = ~vgaclk;
        
endmodule

// #(parameter
// 							HACTIVE = 10'd800,
//                             HFP= 10'd40,
// 							HSYN = 10'd128,
// 							HBP = 10'd88,
// 							HMAX = HACTIVE+HFP+HSYN+HBP,
// 							VACTIVE = 10'd600,
// 							VFP = 10'd1,
// 							VSYN = 10'd4,
// 							VBP = 10'd23,
//                             VMAX = VACTIVE+VFP+VSYN+VBP)
//for 640*480

module vgaController 
#(parameter
							HACTIVE = 10'd640,
                            HFP= 10'd16,
							HSYN = 10'd96,
							HBP = 10'd48,
							HMAX = HACTIVE+HFP+HSYN+HBP,
							VACTIVE = 10'd480,
							VFP = 10'd11,
							VSYN = 10'd2,
							VBP = 10'd32,
                            VMAX = VACTIVE+VFP+VSYN+VBP)
	 	(input logic vgaclk,
        output logic hsync, vsync, sync_b, blank_b,
	 	output logic [9:0] x, y);

        initial begin
            x = 0;
            y = 0;
        end
        
        // counters for horizontal and vertical positions
        // x starts at 0 and goes to 639 for screen values
        //y goes 479
        always @(posedge vgaclk) begin
        x++;
        if (x == HMAX) begin
                x = 0;
                y++;
                if (y == VMAX) y = 0;
        end
        end
        // compute sync signals (active low)
        //640x480
        assign hsync = ~(x >= HACTIVE+HFP & x < HACTIVE+HFP+HSYN);
        assign vsync = ~(y >= VACTIVE+VFP & y < VACTIVE+VFP+VSYN);

        // assign hsync = (x >= HACTIVE+HFP & x < HACTIVE+HFP+HSYN);
        // assign vsync = (y >= VACTIVE+VFP & y < VACTIVE+VFP+VSYN);
        assign sync_b = hsync & vsync;
        // force outputs to black when outside display area
        assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule