// 2 flip flop synchonizer
`timescale 1ns / 1ps

module doubleff_sync(clk,rst,d,q);
parameter WIDTH = 4;

input clk,rst;
input [WIDTH-1:0] d;
output reg [WIDTH-1:0] q;
reg [WIDTH-1:0] d1d2_0;

always @(posedge clk or negedge rst) begin
   if(!rst) begin
     {d1d2_0,q} <= 0;
   end
   else begin
       d1d2_0 <= d;
       q <= d1d2_0;
       end
end


endmodule
