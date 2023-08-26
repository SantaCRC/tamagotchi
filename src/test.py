import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles, Timer




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
    for i in range(10):
        await Timer(0.1, units='sec')
        dut._log.info("status: %d" % dut.status.value)
        dut._log.info("h: %d" % dut.tt_um_santacrc_tamagotchi.hygiene.value)
    

