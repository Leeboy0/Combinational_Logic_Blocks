# Combinational Logic Blocks
> RTL implementations of combinational logic blocks using SystemVerilog

## Overview
This repository contains SystemVerilog implementations of fundamental combinational 
logic blocks, each verified through simulation with waveform analysis.

## Implemented Modules

| Module | Description | Status |
|---|---|---|
| One-bit Adder | Full adder with carry out | ✅ Complete |
| Four-bit Adder | Ripple carry adder with carry out | ✅ Complete |
| 4-to-1 MUX | Multiplexer with 2-bit select | ✅ Complete |

## Tools Used
- **Simulator:** ModelSim Intel FPGA Starter Edition / GTKWave
- **Language:** SystemVerilog (IEEE 1800-2012)
- **Version Control:** Git

## Repository Structure
```
Combinational_Logic_Blocks/
├── one_bit_adder/
│   ├── one_bit_adder.sv
│   └── one_bit_adder_tb.sv
├── four_bit_adder/
│   ├── four_bit_adder.sv
│   └── four_bit_adder_tb.sv
└── mux4to1/
    ├── mux4to1.sv
    └── mux4to1_tb.sv
```

## Simulation Results
Each module has been verified through simulation. Waveforms confirm correct 
functional behavior across all input combinations.

## Roadmap
- [ ] Synthesis using Yosys
- [ ] Add more combinational blocks (encoder, decoder, priority MUX)
- [ ] Add timing analysis

## Last Updated
February 24, 2026