`timescale 1ns/1ps

module tic_tac_toe(
    input wire clk,
    input wire rst_n,
    input wire [3:0] move_idx,
    input wire move_en,
    output reg [17:0] board_out,
    output reg turn,
    output reg invalid_move,
    output reg [1:0] winner
);

    reg [1:0] board [0:8];
    integer i;
    reg [1:0] win_detected;
    reg winner_locked;
    reg [3:0] filled_count;

    // --- Check win condition (combinational)
    always @(*) begin
        win_detected = 2'b00;
        if (board[0]!=2'b00 && board[0]==board[1] && board[1]==board[2]) win_detected = board[0];
        else if (board[3]!=2'b00 && board[3]==board[4] && board[4]==board[5]) win_detected = board[3];
        else if (board[6]!=2'b00 && board[6]==board[7] && board[7]==board[8]) win_detected = board[6];
        else if (board[0]!=2'b00 && board[0]==board[3] && board[3]==board[6]) win_detected = board[0];
        else if (board[1]!=2'b00 && board[1]==board[4] && board[4]==board[7]) win_detected = board[1];
        else if (board[2]!=2'b00 && board[2]==board[5] && board[5]==board[8]) win_detected = board[2];
        else if (board[0]!=2'b00 && board[0]==board[4] && board[4]==board[8]) win_detected = board[0];
        else if (board[2]!=2'b00 && board[2]==board[4] && board[4]==board[6]) win_detected = board[2];
    end

    // --- Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 9; i = i + 1)
                board[i] <= 2'b00;
            turn <= 1'b1;
            invalid_move <= 0;
            winner <= 2'b00;
            winner_locked <= 0;
            filled_count <= 0;
            board_out <= 18'b0;
        end else begin
            invalid_move <= 0;

            // Detect winner
            if (!winner_locked) begin
                if (win_detected == 2'b01) begin
                    winner <= 2'b01; winner_locked <= 1;
                end else if (win_detected == 2'b10) begin
                    winner <= 2'b10; winner_locked <= 1;
                end else begin
                    winner <= 2'b00;
                end
            end

            // Handle move
            if (move_en) begin
                if (winner_locked || move_idx > 8) begin
                    invalid_move <= 1;
                end else if (board[move_idx] == 2'b00) begin
                    board[move_idx] <= turn ? 2'b01 : 2'b10;
                    filled_count <= filled_count + 1;
                    turn <= ~turn;
                end else begin
                    invalid_move <= 1;
                end
            end

            // Draw check
            if (!winner_locked && filled_count == 9) begin
                winner <= 2'b11;
                winner_locked <= 1;
            end

            // Pack board for waveform
            board_out <= {
                board[8], board[7], board[6],
                board[5], board[4], board[3],
                board[2], board[1], board[0]
            };
        end
    end

endmodule
