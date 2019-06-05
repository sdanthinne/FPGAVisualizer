`timescale 1ns/1ps
//testing module to show output of the xadc to the seven segment display

module adcTop(vpin,vnin,seg,an,clk,led);
    input vpin,vnin,clk;
    //logic vnin = 1'b0;
    output [6:0] seg;
    output [3:0] an;
    output logic [15:0] led;
    logic [15:0] data_out;
    logic [11:0] data;
    
    logic ready;
    logic clkslo;
    reg [15:0] cnt;
    
    always @(posedge clk)
        {clkslo, cnt} <= cnt + 16'h2000;  // divide by 4: (2^16)/4 = 0x4000
     
    data_reader d1 (clk, vpin,vnin,data_out,ready);
    seven_segment s1 (clk,1'b1,data,an,seg);
    
    always @ (posedge clk)
    begin
        if(ready)
        begin
            data = data_out[15:4];
            $display(data_out);
        end
    end
    

    
    //LED on board
    always_comb
    begin
        led = data_out;
    end
endmodule