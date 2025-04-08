`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,     // X input
    input  wire [7:0] uio_in,    // Y input
    output reg  [7:0] uo_out,    // Approximate square root output
    output wire [7:0] uio_out,   // IOs: Output path
    output wire [7:0] uio_oe,    // IOs: Enable path
    input  wire       ena,       // Enable (ignored)
    input  wire       clk,       // Clock signal
    input  wire       rst_n      // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0]  sqrt_est;

    // Simple approximation using Newton-Raphson (2 iterations max)
    function [7:0] sqrt_approx;
        input [15:0] x;
        reg [7:0] guess;
        begin
            guess = 8'd16; // initial guess
            guess = (guess + (x / guess)) >> 1;
            guess = (guess + (x / guess)) >> 1;
            sqrt_approx = guess;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            sum_squares = ui_in * ui_in + uio_in * uio_in;
            sqrt_est = sqrt_approx(sum_squares);
            uo_out <= sqrt_est;
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
