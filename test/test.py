# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_fsm(dut):
    dut._log.info("Iniciando prueba FSM")

    # Crear un reloj de 100 kHz (10 us de periodo)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset y señales iniciales
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Simular botón L1 (ui_in[1] = 1)
    dut._log.info("Llamando al piso 1 (L1)")
    dut.ui_in.value = 0b00000010  # Bit 1 en alto
    await ClockCycles(dut.clk, 5)

    # Soltar el botón
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 10)

    # Leer y mostrar salidas
    out_val = dut.uo_out.value.integer
    dut._log.info(f"uo_out: bin = {dut.uo_out.value.binstr}, int = {out_val}")

    # Verificar si L1_out (bit 3) está en alto
    assert (out_val >> 3) & 1 == 1, "ERROR: L1_out (bit 3) debería estar activo"

    # Mostrar todos los bits por si necesitas debug extra
    for i in range(8):
        dut._log.info(f"uo_out[{i}] = {(out_val >> i) & 1}")
