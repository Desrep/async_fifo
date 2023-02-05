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
