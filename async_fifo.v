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

///////////////////////////////////////////////////////////////////
// async fifo //

module async_fifo #(
parameter WIDTH = 4,
parameter W_SIZE = 32
)
(
`ifdef USE_POWER_PINS
    input wire vccd1,        // User area 1 1.8V supply
    input wire vssd1,       // User area 1 digital ground
`endif

input wire rst1,
input wire count1,
input wire rst2,
input wire count2,

input wire clk1,
input wire clk2,
input  wire [W_SIZE-1:0] wdata,
output [W_SIZE-1:0] rdata,
output full,
output  empty
);


//wire rst1,count1,rst2,count2,clk1,clk2,empty,full;
//wire [W_SIZE-1:0] wdata;
reg [W_SIZE-1:0] rdata;
reg full;
reg empty;

wire [WIDTH-1:0] pread,pwrite; // pointers and synchronized pointers
wire [WIDTH-2:0] radd,wadd; // address size is 1 less than pointers
wire [W_SIZE-1:0] rdata0,float_data;

wire empty0,full0,mem_en;

fast_fifo fifo1(
          `ifdef USE_POWER_PINS
                .vccd1(vccd1),
		.vssd1(vssd1),
	   `endif
         
 	.clk1(clk1),
	.rst1(rst1),
	.count1(count1),
	.full(full),
	.pointerinw(pread),
	.pointeroutw(pwrite),
	.wadd(wadd),
	.mem_en(mem_en)
);

slow_fifo fifo2(
         
           `ifdef USE_POWER_PINS
                .vccd1(vccd1),
                .vssd1(vssd1),
           `endif
	

	.clk2(clk2),
	.rst2(rst2),
	.count2(count2),
	.empty(empty),
	.pointerinr(pwrite),
	.pointeroutr(pread),
	.radd(radd)
);
// this sram uses a .lib file
sky130_sram_1kbyte_1rw1r_32x256_8  sram0(

    .clk0(clk1),
   .csb0(full),
   .web0(mem_en),
    .wmask0({count1,count1,count1,count1}),
    .addr0(wadd),
    .din0(wdata),
    .dout0(float_data),

   .clk1(clk2),
   .csb1(empty),
    .addr1(radd),
    .dout1(rdata)
);

endmodule
