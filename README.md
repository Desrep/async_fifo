# async_fifo
A simple asynchronous fifo using a gray counter
The top file, async_fifo.v has the control signals count1 and count2, count1 is an enable for the writing side. Only when this signal is high can wdata be written into the memory. Count2 signal is the enable for the read side, rdata can be read when this signal is high. The full and empty signals go high when the buffer is full or empty respectively. Clk1 is the clock for the writing side and clk2 is the clock of the reading side.
The sram file provided is only a placeholder, it should be replaced with a proper macro when it's implemented. The organization of this architecture is intended to be easy to include in the caravel project where "slow_fifo" "fast_fifo" and the sram used should be included as maros.
A similar fifo can be simulated here:
https://www.edaplayground.com/x/EsvW
