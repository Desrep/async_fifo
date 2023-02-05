# async_fifo
A simple asynchronous fifo using a gray counter
The top file, async_fifo.v has the control signals count1 and count2, count1 is an enable for the writing side. Only when this signal is high can wdata be written into the memory. Count2 signal is the enable for the read side, rdata can be read when this signal is high. The full and empty signals go high when the buffer is full or empty respectively.
The sram file provided is only a placeholder, it should be replaced with a proper macro when it's implemented.
A similar fifo can be simulated here:
https://www.edaplayground.com/x/EsvW
