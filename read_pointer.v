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

// read pointer to address memory
// generates empty signal
`timescale 1ns / 1ps

module read_pointer(clk,count,rpointer,wpointer,raddr,empty,rst);

parameter ADDBITS = 2;
parameter WIDTH = ADDBITS+1;

input clk,count,rst;
output reg empty;
input [WIDTH-1:0] wpointer;
output reg [WIDTH-1:0] rpointer;
output reg [ADDBITS-1:0] raddr;
wire [WIDTH-1:0] raddr0,rpointer0,gray_next;
wire empty_sig;
wire enable;

gray_counter #(.WIDTH(WIDTH)) gc(.clk(clk),.count(count),.enable(enable),.out_gray(rpointer0),.out_bin(raddr0),.gray_next(gray_next),.rst(rst));


always @* begin
 raddr = raddr0[WIDTH-2:0]; // waddr has 1 bit less
  rpointer = rpointer0;
end

//Generate full singal, synchronous
assign empty_sig = (gray_next == wpointer);

always @(posedge clk or negedge rst) begin
    if(!rst) 
        empty <= 1;
    else
        empty <= empty_sig;

end

assign enable = count&(~empty);

endmodule
