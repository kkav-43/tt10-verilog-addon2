`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,     // X input
    input  wire [7:0] uio_in,    // Y input
    output reg  [7:0] uo_out,    // Approximate magnitude output
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            // Approximate magnitude: max(x, y) + (min(x, y) >> 1) - 1
            reg [7:0] x, y, max_val, min_val;
            reg [7:0] approx;

            x = ui_in;
            y = uio_in;
            max_val = (x > y) ? x : y;
            min_val = (x > y) ? y : x;

            approx = max_val + (min_val >> 1) - 1;

            uo_out <= approx;
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
