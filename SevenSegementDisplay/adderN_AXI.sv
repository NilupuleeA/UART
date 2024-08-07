`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 10:47:08
// Design Name: 
// Module Name: adder_AXI
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adderN_AXI #(
    parameter N = 10,
              WIDTH = 8
)(
    input logic clk, rstn, m_ready, s_valid, 
    input logic [WIDTH-1:0] s_data,
    output logic s_ready, m_valid,
    output logic [1:0][6:0] m_data
);

    enum logic {RX=0, TX=1} state, next_state;
    logic [$clog2(N)-1:0] count;
    logic [WIDTH + $clog2(N)-1:0] sum_reg;
    logic [3:0] modulo_result, remainder_result;

    // Next state logic
    always_comb begin
        unique case (state)
            RX: next_state = (count == N-1) && s_valid ? TX : RX;
            TX: next_state = m_ready ? RX : TX;
            default: next_state = RX;
        endcase
    end

    // State transition
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= RX;
        else
            state <= next_state;
    end

    assign s_ready = (state == RX);
    assign m_valid = (state == TX);

    // Shift register and counter logic
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= '0;
            sum_reg <= '0;
        end else begin
            unique case (state)
                RX: if (s_valid) begin
                    sum_reg <= sum_reg + s_data;
                    count <= count + 1;
                    modulo_result <= sum_reg % 10;  // Modulo 10 operation
                    remainder_result <= sum_reg / 10;  // Division by 10
                end
                TX: if (m_ready) begin
                    m_data[0] = sevenSegment(modulo_result);
                    m_data[1] = sevenSegment(remainder_result);
                    sum_reg <= '0;
                    count <= '0; // Reset sum_reg after transmission
                end
            endcase
        end
    end

    function [6:0] sevenSegment(
        input logic [3:0] X
    );
        logic [6:0] Y;
        begin
            case (X)
                4'd0: Y = 0; //7'b0111111; // 0
                4'd1: Y = 1; //7'b0000110; // 1
                4'd2: Y = 2; //7'b1011011; // 2
                4'd3: Y = 3; //7'b1001111; // 3
                4'd4: Y = 4; //7'b1100110; // 4
                4'd5: Y = 5; //7'b1101101; // 5
                4'd6: Y = 6; //7'b1111101; // 6
                4'd7: Y = 7; //7'b0000111; // 7
                4'd8: Y = 8; //7'b1111111; // 8
                4'd9: Y = 9; //7'b1101111; // 9
                default: Y = 7'b100000; // Default to all off
            endcase
            sevenSegment = Y;
        end
    endfunction

endmodule
