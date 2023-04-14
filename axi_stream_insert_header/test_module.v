`timescale 1ns / 1ps
`include "./axi_stream_insert_header.v"
module test_module;

    parameter PERIOD = 10;
    parameter DATA_WD = 32;
    parameter DATA_BYTE_WD = DATA_WD / 8;
    parameter BYTE_CNT_WD = $clog2(DATA_BYTE_WD);
    parameter tb_datain_depth = 4;

    // axi_stream_insert_header Inputs
    reg                       clk = 1;
    reg                       rst_n = 0;
    reg                       valid_in = 0;
    reg  [     DATA_WD-1 : 0] data_in = 0;
    reg  [DATA_BYTE_WD-1 : 0] keep_in = 0;
    reg                       ready_out = 1;
    reg                       valid_insert = 0;
    reg  [     DATA_WD-1 : 0] header_insert = 0;
    reg  [DATA_BYTE_WD-1 : 0] keep_insert = 0;

    // axi_stream_insert_header Outputs
    wire                      ready_in;
    wire                      valid_out;
    wire [     DATA_WD-1 : 0] data_out;
    wire [DATA_BYTE_WD-1 : 0] keep_out;
    wire                      last_out;
    wire                      ready_insert;
    reg                       last_in = 0;
    reg valid_insert_tmp;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            valid_insert_tmp <= 0;
        else begin
            valid_insert_tmp <= ready_in;
        end
    end

    initial begin
        forever #(PERIOD / 2) clk = ~clk;
    end

    integer seed;
    initial begin
        seed = 2;
    end

    initial begin
        #(PERIOD) rst_n = 1;
        #(PERIOD * 200);
        $finish;
    end

    initial begin
        //第一组
        // 一直重复，直到valid_insert随机生成1时，才跳出。
        while (!valid_insert) begin
            #(PERIOD)
            valid_insert = $random(seed) % 2;
            header_insert = $random(seed);
            keep_insert ={$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b0001 : 4'b0011) : ({$random(seed)} % 2 ? 4'b0111 : 4'b1111);;
        end

        // 一直重复，直到valid_in随机生成1时，才跳出。
        while (!valid_in) begin
            #(PERIOD)
            valid_in = $random(seed) % 2;
            data_in = $random(seed);
            keep_in = 4'b1111;
        end

        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        
        #(PERIOD)begin
        data_in = $random(seed);
        keep_in = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b1111 : 4'b1110) : ({$random(seed)} % 2 ? 4'b1100 : 4'b1000);
        last_in = 1;
        end
        #(PERIOD)begin
            valid_insert = 0;
            valid_in = 0;
            data_in = 0;
            last_in = 0;
            header_insert = 0;
            keep_insert =0;
        end
        #(PERIOD);

        //第二组

        while (!valid_insert) begin
            #(PERIOD)
            valid_insert = $random(seed) % 2;
            header_insert = $random(seed);
            keep_insert = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b0001 : 4'b0011) : ({$random(seed)} % 2 ? 4'b0111 : 4'b1111);
        end

        while (!valid_in) begin
            #(PERIOD)
            valid_in = $random(seed) % 2;
            data_in = $random(seed);
            keep_in = 4'b1111;
        end

        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        
        #(PERIOD)begin
        data_in = $random(seed);
        keep_in = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b1111 : 4'b1110) : ({$random(seed)} % 2 ? 4'b1100 : 4'b1000);
        last_in = 1;
        end
        #(PERIOD)begin
            valid_insert = 0;
            valid_in = 0;
            data_in = 0;
            last_in = 0;
            header_insert = 0;
            keep_insert =0;
        end
        #(PERIOD);

        //第三组

        while (!valid_insert) begin
            #(PERIOD)
            valid_insert = $random(seed) % 2;
            header_insert = $random(seed);
            keep_insert = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b0001 : 4'b0011) : ({$random(seed)} % 2 ? 4'b0111 : 4'b1111);
        end

        while (!valid_in) begin
            #(PERIOD)
            valid_in = $random(seed) % 2;
            data_in = $random(seed);
            keep_in = 4'b1111;
        end

        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        
        #(PERIOD)begin
        data_in = $random(seed);
        keep_in = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b1111 : 4'b1110) : ({$random(seed)} % 2 ? 4'b1100 : 4'b1000);
        last_in = 1;
        end
        #(PERIOD)begin
            valid_insert = 0;
            valid_in = 0;
            data_in = 0;
            last_in = 0;
            header_insert = 0;
            keep_insert =0;
        end
        #(PERIOD);
        
        //第四组

        while (!valid_insert) begin
            #(PERIOD)
            valid_insert = $random(seed) % 2;
            header_insert = $random(seed);
            keep_insert = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b0001 : 4'b0011) : ({$random(seed)} % 2 ? 4'b0111 : 4'b1111);
        end

        while (!valid_in) begin
            #(PERIOD)
            valid_in = $random(seed) % 2;
            data_in = $random(seed);
            keep_in = 4'b1111;
        end

        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        #(PERIOD)begin
        data_in = $random(seed);
        end
        
        #(PERIOD)begin
        data_in = $random(seed);
        keep_in = {$random(seed)} % 2 ? ({$random(seed)} % 2 ? 4'b1111 : 4'b1110) : ({$random(seed)} % 2 ? 4'b1100 : 4'b1000);
        last_in = 1;
        end
        #(PERIOD)begin
            valid_insert = 0;
            valid_in = 0;
            data_in = 0;
            last_in = 0;
            header_insert = 0;
            keep_insert =0;
        end
        #(PERIOD);
    end
       

    axi_stream_insert_header #(
        .DATA_WD     (DATA_WD),
        .DATA_BYTE_WD(DATA_BYTE_WD)
    ) u_axi_stream_insert_header (
        .clk         (clk),
        .rst_n       (rst_n),
        .valid_in    (valid_in),
        .data_in     (data_in[DATA_WD-1 : 0]),
        .keep_in     (keep_in[DATA_BYTE_WD-1 : 0]),
        .last_in     (last_in),
        .ready_out   (ready_out),
        .valid_insert(valid_insert),
        .header_insert (header_insert[DATA_WD-1 : 0]),
        .keep_insert (keep_insert[DATA_BYTE_WD-1 : 0]),

        .ready_in    (ready_in),
        .valid_out   (valid_out),
        .data_out    (data_out[DATA_WD-1 : 0]),
        .keep_out    (keep_out[DATA_BYTE_WD-1 : 0]),
        .last_out    (last_out),
        .ready_insert(ready_insert)
    );

    

////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wave.vcd");  //生成的vcd文件名称
        $dumpvars(0, test_module);  //tb模块名称
        #20000 $finish;
    end
////////////////////////////////////////////////////////////
endmodule
