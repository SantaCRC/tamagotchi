import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles, Timer
import random



@cocotb.test()
async def status(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1
    dut.ui_in.value = 0
    # set the compare value
    await ClockCycles(dut.clk, 10)

    dut._log.info("check status")
    
    # Use Gate level test or not
    gate_level_test = False
    
    # Check if is gate level test
    try:
        dut.tt_um_santacrc_tamagotchi.hygiene
        dut._log.info("Pre-Sythnesis test")
    except:
        dut._log.info("Gate level test")
        gate_level_test = True
    
    if (not gate_level_test):  
        for i in range(10):
            await Timer(0.1, units='sec')
            dut._log.info("status: %d" % dut.tt_um_santacrc_tamagotchi.status.value)
            dut._log.info("hy: %d" % dut.tt_um_santacrc_tamagotchi.hygiene.value)
            dut._log.info("hu: %d" % dut.tt_um_santacrc_tamagotchi.hunger.value)
            dut._log.info("hp: %d" % dut.tt_um_santacrc_tamagotchi.happiness.value)
            dut._log.info("he: %d" % dut.tt_um_santacrc_tamagotchi.health.value)
            await ClockCycles(dut.clk, 1)
            ini = random.randint(0, 3)
            dut.ui_in[ini].value = 1
            await ClockCycles(dut.clk, 1)
            dut.ui_in[ini].value = 0
    else:
        for i in range(10):
            await Timer(0.1, units='sec')
            try:
                dut._log.info("status: %d" % dut.status.value)
            except:
                pass
            await ClockCycles(dut.clk, 1)
            ini = random.randint(0, 3)
            dut.ui_in[ini].value = 1
            await ClockCycles(dut.clk, 1)
            dut.ui_in[ini].value = 0
        
        
    

