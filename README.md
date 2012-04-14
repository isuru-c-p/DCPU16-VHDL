DCPU16-VHDL
===========

Introduction
------------

A VHDL implementation of the DCPU16 from 0x10c. 

The current implementation is multi-cycle and can probably be made much more efficient. I'm aiming to get it fully functional first before working on converting it
to a pipelined CPU.

The target I will be testing my implementation on is a Altera Cyclone II FPGA on a DE2-70 development board.

Current Status: 
---------------

The core has currently only been tested in simulation using ModelSim. 