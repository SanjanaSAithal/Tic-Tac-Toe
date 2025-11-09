`timescale 1ns/1ps

module tb_tic_tac_toe;

    reg clk = 0;
    reg rst_n = 0;
    reg [3:0] move_idx;
    reg move_en;
    wire [17:0] board_out;
    wire turn;
    wire invalid_move;
    wire [1:0] winner;

    tic_tac_toe dut (
        .clk(clk),
        .rst_n(rst_n),
        .move_idx(move_idx),
        .move_en(move_en),
        .board_out(board_out),
        .turn(turn),
        .invalid_move(invalid_move),
        .winner(winner)
    );

    always #5 clk = ~clk;

    task do_move;
        input [3:0] idx;
        begin
            @(negedge clk);
            move_idx = idx;
            move_en = 1;
            @(negedge clk);
            move_en = 0;
            #1;
            $display("%0t ns | Move=%0d | Turn=%b | Invalid=%b | Winner=%b | Board=%b",
                     $time, idx, turn, invalid_move, winner, board_out);
        end
    endtask

    initial begin
        $dumpfile("tic_tac_toe.vcd");
        $dumpvars(0, tb_tic_tac_toe);

        rst_n = 0; #20; rst_n = 1; #10;

        $display("=== GAME 1: X Wins on Top Row ===");
        do_move(0);
        do_move(3);
        do_move(1);
        do_move(4);
        do_move(2);

        #30;
        $display("Attempt invalid move after win:");
        do_move(5);

        #40;
        $display("=== GAME 2: Draw ===");
        rst_n = 0; #20; rst_n = 1; #10;

        do_move(0);
        do_move(1);
        do_move(2);
        do_move(4);
        do_move(3);
        do_move(5);
        do_move(7);
        do_move(6);
        do_move(8);

        #50;
        $display("Simulation complete. Winner=%b", winner);
        $finish;
    end

endmodule
