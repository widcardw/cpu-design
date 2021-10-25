#!/bin/bash
iverilog -o ./testbench ./testbench.v
vvp ./testbench
