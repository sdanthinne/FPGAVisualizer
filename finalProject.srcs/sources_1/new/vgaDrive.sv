`timescale 1ns/1ps

//author:Sebastien Danthinne

//attempt at a vga driver

//rev: draws some rectangle
//test to see if it works or not
module vgaTop(clk,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync);
    input clk;
    output logic [3:0] vgaRed, vgaBlue, vgaGreen;
    output Hsync,Vsync;
    logic [9:0] x,y;

    vgaClocker vclk (.clk(clk),.vgaclk(vgaclk));
    vgaController vcon (.vgaclk(vgaclk),.hsync(Hsync),.vsync(Vsync),.sync_b(),.blank_b(),.x(x),.y(y));

    always_comb
    begin
        if(y%2 == 0)
        begin
            vgaRed = 4'b1111;
            vgaBlue = 4'b1111;
            vgaGreen = 4'b1111;
        end
        else if(y%2 == 1)
        begin
            vgaRed = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue = 4'b0000;
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
        {st_clk, cnt} <= cnt + 16'h4072;  // divide by 3.9721: (2^16)/3.9721 = 0x4072logic
    
    always @ (posedge st_clk)
        vgaclk = ~vgaclk;
        
endmodule

module vgaController #(parameter
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
        assign hsync = ~(x >= HACTIVE+HFP & x < HACTIVE+HFP+HSYN);
        assign vsync = ~(y >= VACTIVE+VFP & y < VACTIVE+VFP+VSYN);
        assign sync_b = hsync & vsync;
        // force outputs to black when outside display area
        assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule