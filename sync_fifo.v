module sync_fifo
#(
    parameter DATA_WIDTH = 8,
    parameter DATA_DEPTH = 256
)
(
    input clk,
    input wr_en,
    input [DATA_WIDTH - 1 : 0] wr_data,
    output wr_full,
    input rd_en,
    output [DATA_WIDTH - 1 : 0] rd_data,
    output rd_empty
);

reg [DATA_WIDTH - 1 : 0] fifo_buffer[0 : DATA_DEPTH - 1];
reg [$clog2(DATA_DEPTH) : 0] fifo_cnt = 0;

reg [$clog2(DATA_DEPTH) - 1 : 0] wr_pointer = 0;
reg [$clog2(DATA_DEPTH) - 1 : 0] rd_pointer = 0;

always@(posedge clk) 
begin
    if(wr_en && !rd_en) 
    begin  
        fifo_cnt <= fifo_cnt + 1;
    end
    else if(rd_en && !wr_en) 
    begin  
        fifo_cnt <= fifo_cnt - 1;
    end
end

always@(posedge clk) 
begin
    if(wr_en && !wr_full) 
    begin
        if(wr_pointer == DATA_DEPTH - 1) 
        begin
            wr_pointer <= 0; 
        end
        else 
        begin
            wr_pointer <= wr_pointer + 1;
        end       
    end
end
 
always@(posedge clk) 
begin
    if(rd_en && !rd_empty) 
    begin
        if(rd_pointer == DATA_DEPTH - 1) 
        begin
            rd_pointer <= 0;
        end
        else 
        begin
            rd_pointer <= rd_pointer + 1;
        end
    end
end
 
always@(posedge clk) 
begin
    if(wr_en) 
    begin
        fifo_buffer[wr_pointer] <= wr_data;
    end
end

assign rd_data = fifo_buffer[rd_pointer];
assign wr_full = (fifo_cnt == DATA_DEPTH)? 1 : 0;
assign rd_empty = (fifo_cnt == 0) ? 1 : 0;

endmodule