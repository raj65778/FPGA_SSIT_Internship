// dht11_interface.v
module dht11_interface (
    input wire clk,         // 50 MHz clock
    input wire rst,         // active-high reset
    inout wire dht11_data,  // bidirectional data line with DHT11
    output reg [7:0] temperature, // temperature output (integer)
    output reg ready        // goes high when data is valid
);

// Clock and timing constants
parameter CLK_FREQ = 50000000;
parameter TIME_1US = CLK_FREQ / 1000000;

// DHT11 timing states
localparam IDLE       = 0;
localparam START      = 1;
localparam WAIT_RESP  = 2;
localparam RESP_LOW   = 3;
localparam RESP_HIGH  = 4;
localparam READ_BIT   = 5;
localparam WAIT_NEXT  = 6;
localparam DONE       = 7;

reg [2:0] state = IDLE;
reg [19:0] cnt = 0;

reg dht11_out = 1'b1;
reg dht11_dir = 1'b0; // 0 = input, 1 = output

assign dht11_data = dht11_dir ? dht11_out : 1'bz;
wire dht11_in = dht11_data;

reg [5:0] bit_index = 0;
reg [39:0] data_buf = 0;
reg [15:0] pulse_cnt = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        dht11_out <= 1;
        dht11_dir <= 0;
        ready <= 0;
        temperature <= 0;
        bit_index <= 0;
        data_buf <= 0;
    end else begin
        case (state)
            IDLE: begin
                ready <= 0;
                cnt <= cnt + 1;
                if (cnt > 2 * CLK_FREQ) begin // wait ~2s before starting
                    cnt <= 0;
                    state <= START;
                    dht11_dir <= 1;
                    dht11_out <= 0;
                end
            end

            START: begin
                cnt <= cnt + 1;
                if (cnt > 18000 * TIME_1US) begin // ~18ms low
                    dht11_out <= 1;
                    dht11_dir <= 0;
                    cnt <= 0;
                    state <= WAIT_RESP;
                end
            end

            WAIT_RESP: begin
                cnt <= cnt + 1;
                if (!dht11_in) begin
                    cnt <= 0;
                    state <= RESP_LOW;
                end else if (cnt > 100 * TIME_1US) begin
                    state <= IDLE; // timeout
                    cnt <= 0;
                end
            end

            RESP_LOW: begin
                cnt <= cnt + 1;
                if (dht11_in) begin
                    cnt <= 0;
                    state <= RESP_HIGH;
                end
            end

            RESP_HIGH: begin
                cnt <= cnt + 1;
                if (!dht11_in) begin
                    cnt <= 0;
                    bit_index <= 0;
                    data_buf <= 0;
                    state <= READ_BIT;
                end
            end

            READ_BIT: begin
                if (!dht11_in) begin
                    cnt <= 0;
                    state <= WAIT_NEXT;
                end else begin
                    cnt <= cnt + 1;
                    if (cnt > 100 * TIME_1US) begin
                        state <= IDLE; // timeout
                        cnt <= 0;
                    end
                end
            end

            WAIT_NEXT: begin
                cnt <= cnt + 1;
                if (dht11_in) begin
                    cnt <= 0;
                end else if (cnt > 100 * TIME_1US) begin
                    state <= IDLE; // timeout
                    cnt <= 0;
                end else begin
                    pulse_cnt <= pulse_cnt + 1;
                    if (pulse_cnt > 10 * TIME_1US) begin
                        data_buf <= {data_buf[38:0], 1'b1}; // logic '1'
                    end else begin
                        data_buf <= {data_buf[38:0], 1'b0}; // logic '0'
                    end
                    pulse_cnt <= 0;
                    bit_index <= bit_index + 1;
                    if (bit_index == 39)
                        state <= DONE;
                    else
                        state <= READ_BIT;
                end
            end

            DONE: begin
                temperature <= data_buf[23:16]; // second byte = temperature
                ready <= 1;
                state <= IDLE;
                cnt <= 0;
            end
        endcase
    end
end

endmodule
