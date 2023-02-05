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

module slow_fifo #(
parameter WIDTH = 4,
parameter W_SIZE = 32
)
(
`ifdef USE_POWER_PINS
    inout vccd1,        // User area 1 1.8V supply
    inout vssd1,        // User area 1 digital ground
`endif

input wire clk2,
input wire rst2,
input wire count2,
input [WIDTH-1:0] pointerinr,
output  [WIDTH-1:0] pointeroutr,
output  empty,
output  [WIDTH-2:0] radd
);

reg [WIDTH-1:0] pointeroutr;
reg empty;
reg [WIDTH-2:0] radd;

wire [WIDTH-1:0] pt2,p1p2; // pointers and synchronized pointers
wire [WIDTH-2:0] radd0; // address size is 1 less than pointers
  wire [W_SIZE-1:0] rdata0;
wire empty0;

doubleff_sync #(.WIDTH(WIDTH)) s2(.clk(clk2),.rst(rst2),.d(pointerinr),.q(p1p2));
read_pointer #(.ADDBITS(WIDTH-1)) rp(.clk(clk2),.count(count2),.rpointer(pt2),.wpointer(p1p2),.raddr(radd0),.empty(empty0),.rst(rst2));

always @* begin
    empty = empty0;
    pointeroutr = pt2;
    radd = radd0;

end
  
endmodule
