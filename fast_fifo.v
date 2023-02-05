/* Copyright 2023 Fereie

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////

// Note that clk1 is the fastest clock, this fifo only works from a faster writer to a slower reader"
// A dual clock dual port memory would be needed to make it work for all cases
module fast_fifo #(parameter WIDTH = 4,
	parameter W_SIZE = 32)
(

`ifdef USE_POWER_PINS
    inout vccd1,        // User area 1 1.8V supply
    inout vssd1,        // User area 1 digital ground
`endif

input wire rst1,
input wire count1,
input wire clk1,
input [WIDTH-1:0] pointerinw,
output [WIDTH-1:0] pointeroutw,
output  full,
output  [WIDTH-2:0] wadd,
output  mem_en
);
reg [WIDTH-1:0] pointeroutw;
reg full;
reg [WIDTH-2:0] wadd;
reg mem_en;


wire [WIDTH-1:0] pt1,p2p1; // pointers and synchronized pointers
wire [WIDTH-2:0] wadd0; // address size is 1 less than pointers

wire full0,full1;
wire mem_en0;

doubleff_sync #(.WIDTH(WIDTH)) s1(.clk(clk1),.rst(rst1),.d(pointerinw),.q(p2p1)); // synchronizer
write_pointer #(.ADDBITS(WIDTH-1)) wp(.clk(clk1),.count(count1),.rpointer(p2p1),.wpointer(pt1),.waddr(wadd0),.full(full0),.rst(rst1));

//dp_rf  #(.WIDTH(W_SIZE), .ABITNUM(WIDTH-1)) dmem(.wdata(wdata),.rdata(rdata0),.wadd(wadd),.radd(radd),.clk(clk1),.en(mem_en));

assign mem_en0 = count1&(~full)&(rst1); // disable memory if full

always @* begin    
    full = full0;
    pointeroutw = pt1;
    mem_en = ~mem_en0;
    wadd = wadd0;
end

endmodule
