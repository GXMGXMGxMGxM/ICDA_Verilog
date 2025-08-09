module sync_fifo_tb();

parameter DATA_WIDTH = 8;
parameter DATA_DEPTH = 256;

reg clk;
reg wr_en;
reg [DATA_WIDTH - 1 : 0] wr_data;
wire wr_full;
reg rd_en;
wire [DATA_WIDTH - 1 : 0] rd_data;
wire rd_empty;
initial 
begin
	clk = 0;
	forever 
    begin
		#10 clk = ~clk;
	end
end
initial 
begin
	wr_en = 0;
	rd_en = 0;
	@(negedge clk) wr_en = 1;
	wr_data = $random;
	repeat(7) 
	begin
		@(negedge clk)
		wr_data = $random;	
	end
	@(negedge clk)
	wr_en = 0;
	rd_en = 1;
	repeat(7) 
	begin
		@(negedge clk);	
	end
	@(negedge clk)
	rd_en = 0;
	wr_en = 1;
	wr_data = $random;
	repeat(7) 
	begin   		
		@(negedge clk)
		wr_data = $random;
	end
	@(negedge clk)
	wr_en = 0;
	rd_en = 1;
	repeat(7) 
	begin
		@(negedge clk);	
	end
	#20 $finish;
end

//实例化我们自己的简易同步FIFO
/*
sync_fifo 
#(
	.DATA_WIDTH(DATA_WIDTH),
	.DATA_DEPTH(DATA_DEPTH)
)
u_sync_fifo_own
(
	.clk        (clk),
	.wr_en      (wr_en),
	.wr_data    (wr_data),
	.wr_full    (wr_full),
	.rd_en      (rd_en),
	.rd_data    (rd_data),
	.rd_empty   (rd_empty)
);
*/

//实例化VIVADO的简易同步FIFO IP核
/*
sync_fifo  u_sync_fifo_ip
(
	.clk		(clk),     
	.din		(wr_data),     
	.wr_en		(wr_en), 
	.rd_en		(rd_en), 
	.dout		(rd_data),   
	.full		(wr_full),   
	.empty		(rd_empty)  
);
*/

endmodule
