//the Gray code pointer for the Fifo (addresses the memory)
// generates the full signal
`timescale 1ns / 1ps

module write_pointer(clk,count,rpointer,wpointer,waddr,full,rst);

parameter ADDBITS = 2;
parameter WIDTH = ADDBITS+1;





input clk,count,rst;
output reg full;
input [WIDTH-1:0] rpointer;
output reg [WIDTH-1:0] wpointer;
output reg [ADDBITS-1:0] waddr;
wire [WIDTH-1:0] waddr0,wpointer0,gray_next;
wire full_sig;
wire enable;

gray_counter #(.WIDTH(WIDTH)) gc(.clk(clk),.count(count),.enable(enable),.out_gray(wpointer0),.out_bin(waddr0),.gray_next(gray_next),.rst(rst));


always @* begin
  waddr = waddr0[WIDTH-2:0]; // waddr has 1 bit less
  wpointer = wpointer0;
end

//Generate full singal, synchronous
assign full_sig = ((rpointer[WIDTH-1] != gray_next[WIDTH-1])&&(rpointer[WIDTH-2] != gray_next[WIDTH-2])&&(rpointer[WIDTH-3:0] == gray_next[WIDTH-3:0]));

always @(posedge clk or negedge rst) begin
    if(!rst) 
        full <= 0;
    else
        full <= full_sig;
end

assign enable = count&(~full);

endmodule
