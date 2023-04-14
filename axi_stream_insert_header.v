module axi_stream_insert_header #(
    parameter DATA_WD = 32,
    parameter DATA_BYTE_WD = DATA_WD / 8
) (
    input                       clk,
    input                       rst_n,
    // AXI Stream input original data
    input                       valid_in,
    input  [     DATA_WD-1 : 0] data_in,
    input  [DATA_BYTE_WD-1 : 0] keep_in,
    input                       last_in,
    output                      ready_in,
    // AXI Stream output with header inserted
    output                      valid_out,
    output [     DATA_WD-1 : 0] data_out,
    output [DATA_BYTE_WD-1 : 0] keep_out,
    output                      last_out,
    input                       ready_out,
    // The header to be inserted to AXI Stream input
    input                       valid_insert,
    input  [     DATA_WD-1 : 0] header_insert,
    input  [DATA_BYTE_WD-1 : 0] keep_insert,
    output                      ready_insert
);
    // Your code here
    reg [DATA_BYTE_WD-1:0] head_valid_num;
    reg [     DATA_WD-1 : 0] header_tmp;
    reg [DATA_BYTE_WD-1 : 0] keep_in_tmp;
    reg [   2*DATA_WD-1 : 0] data_in_tmp;
    reg [     DATA_WD-1 : 0] data_out_tmp;
    reg second_cycle;
    reg input_over_flag;
    reg output_over_flag;
    reg ready_insert_tmp;
    reg [DATA_BYTE_WD-1 : 0] keep_out_tmp;
    reg last_out_tmp;
    reg valid_out_tmp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            header_tmp <= 0;
            head_valid_num <= 0;
            data_in_tmp <= 0;
            second_cycle <= 0;
            input_over_flag <= 0;
            output_over_flag <= 0;
            ready_insert_tmp <= 1;
            last_out_tmp <= 0;
            valid_out_tmp <= 0;
            keep_out_tmp <= 0;
            keep_in_tmp <= 0;
        end else begin
            if(valid_insert && ready_insert)begin//tb里面，这两个信号同时拉高一个周期
                output_over_flag <= 0;
                header_tmp <= header_insert;
                head_valid_num <= count_ones_4bit(keep_insert);
                second_cycle <= 1;
                last_out_tmp <= 0;
                data_out_tmp <= 0;
                ready_insert_tmp <= 0;
                valid_out_tmp <= 0;
            end
            else if(valid_in && ready_in && second_cycle ) begin
                data_in_tmp <= {header_tmp,data_in};
                second_cycle <= 0;
                data_out_tmp <= 0;
            end
            else if(valid_in && (~second_cycle) && (~input_over_flag) &&(~output_over_flag) && (~last_in)) begin
                keep_out_tmp <= {DATA_BYTE_WD{1'b1}};
                data_in_tmp <= {data_in_tmp[DATA_WD-1 : 0],data_in};
                data_out_tmp <= data_in_tmp >> multiply(head_valid_num,8);
                input_over_flag <= 0;
                valid_out_tmp <= 1;
            end
            else if(valid_in && (~second_cycle) && (~input_over_flag) &&(~output_over_flag) && last_in) begin
                keep_out_tmp <= {DATA_BYTE_WD{1'b1}};
                data_in_tmp <= {data_in_tmp[DATA_WD-1 : 0],data_in};
                data_out_tmp <= data_in_tmp >> multiply(head_valid_num,8);
                input_over_flag <= 1;
                valid_out_tmp <= 1;
                keep_in_tmp <= keep_in;
            end
            else if(input_over_flag) begin
                keep_out_tmp <= {DATA_BYTE_WD{1'b1}};
                data_out_tmp <= data_in_tmp >> multiply(head_valid_num,8);
                output_over_flag <= 1;
                ready_insert_tmp <= 1;
                valid_out_tmp <= 1;
                input_over_flag <= 0;
            end
            else if(output_over_flag) begin
                data_out_tmp <= data_in_tmp << multiply((DATA_BYTE_WD-head_valid_num),8);
                keep_out_tmp <= keep_in_tmp << (DATA_BYTE_WD-head_valid_num);
                
                last_out_tmp <= 1;
                valid_out_tmp <= 1;
            end
            else begin
                //valid_out_tmp <= 0;
                //ready_insert_tmp <= 1;
                //last_out_tmp <= 0;
                //data_out_tmp <= 0;
                //header_tmp <= 0;
                head_valid_num <= 0;
                data_in_tmp <= 0;
                second_cycle <= 0;
                input_over_flag <= 0;
                output_over_flag <= 0;
                ready_insert_tmp <= 1;
                last_out_tmp <= 0;
                valid_out_tmp <= 0;
                keep_out_tmp <= 0;
                keep_in_tmp <= 0;
                data_out_tmp <= 0;
            
            end
        end
    end
    //assign ready_in = ~valid_out && ready_out_tmp ;
    assign ready_in = ~valid_out || output_over_flag;
    assign data_out = data_out_tmp;
    assign ready_insert = ready_insert_tmp;
    assign valid_out = valid_out_tmp;
    assign last_out = last_out_tmp;
    assign keep_out = keep_out_tmp;
    //function automatic integer count_ones_4bit(input [3:0] data_in);
        //integer cnt;
        //begin
            //cnt = 0;
            //cnt = cnt + (data_in[0] & 1'b1);
            //cnt = cnt + (data_in[1] & 1'b1);
            //cnt = cnt + (data_in[2] & 1'b1);
            //cnt = cnt + (data_in[3] & 1'b1);
            //count_ones_4bit = cnt;
        //end
    //endfunction
    function automatic integer count_ones_4bit(input [3:0] data_in);
    integer cnt;
    begin
        cnt = data_in[0];
        cnt = cnt + data_in[1];
        cnt = cnt + data_in[2];
        cnt = cnt + data_in[3];
        count_ones_4bit = cnt;
    end
    endfunction
    //function automatic integer count_ones_4bit(input [3:0] data_in);
        //integer cnt;
        //integer i;
        //begin
            //cnt = 0;
            //for (i = 0; i < DATA_BYTE_WD; i = i + 1) begin
                //cnt = cnt + data_in[i];
            //end
            //count_ones_4bit = cnt;
        //end
    //endfunction
    function automatic integer multiply(input [3:0]a,b);
    integer i;
    begin
        multiply= 0;
        for(i = 0; i < 4; i = i + 1)begin
            if(b[i])begin
                multiply = multiply + a  << i;
            end
        end
    end
    endfunction
endmodule
