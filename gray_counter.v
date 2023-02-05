// Gray counter it outputs the next gray value, the current gray value and the binary count
// the binary count is used to address memory and the gray count is used for synchronization
`timescale 1ns / 1ps

module gray_counter(clk,count,enable,rst,out_bin,out_gray,gray_next);
  parameter WIDTH = 4;


  input clk;
  input count;
  input enable;
  input rst;
  output reg [WIDTH-1:0] out_bin; // output only binary  count
  output reg [WIDTH-1:0] out_gray; // output gray count
  output reg [WIDTH-1:0] gray_next; // output gray for comparisson
  wire count_enable;
  wire [WIDTH-1:0] bin_next;
  wire [WIDTH-1:0] bin2gray;
  reg [WIDTH-2:0] concat = 0;

  assign bin_next = {concat,count_enable}+out_bin;

  always @(negedge clk or negedge rst) begin
    if(!rst) begin
      out_bin <= 0;
    end
    else
      out_bin<= bin_next;
  end

  always @(negedge clk or negedge rst) begin
    if(!rst)
      out_gray <= 0;
    else
      out_gray <= bin2gray;
  end

  assign count_enable = count&enable;

  assign bin2gray = (bin_next>>1)^bin_next;

  always @*
  begin
    gray_next = bin2gray;
  end

endmodule
                                                                                                                                                                                                        
