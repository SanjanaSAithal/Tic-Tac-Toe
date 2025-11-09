# Tic Tac Toe Game in Verilog

### Project Overview
This project implements a **3x3 Tic Tac Toe game** in **Verilog HDL**.  
It simulates two-player gameplay, detects valid moves, identifies winners,  
and handles draw and invalid-move conditions.

### Components
- **tic_tac_toe.v** — Verilog design module  
- **tb_tic_tac_toe.v** — Testbench for simulation  
- **tic_tac_toe.vcd** — GTKWave output waveform  

### Tools Used
- iVerilog for simulation  
- GTKWave for waveform analysis  

### How to Run
```bash
iverilog -o ttt tic_tac_toe.v tb_tic_tac_toe.v
vvp ttt
gtkwave tic_tac_toe.vcd
