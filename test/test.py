# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_fsm(dut):
    dut._log.info("Iniciando prueba FSM")

    # Crear el reloj de 10us (100kHz, puedes ajustar si necesitas)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Inicialización
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # Simulamos presionar L1 (ir al piso 1)
    dut._log.info("Llamando a piso 1")
    dut.ui_in.value = 0b00000010  # L1=1
    await ClockCycles(dut.clk, 2)

    dut.ui_in.value = 0  # Soltar botón
    await ClockCycles(dut.clk, 5)

    dut._log.info(f"Salidas: uo_out = {dut.uo_out.value.binstr}")

    # Aquí puedes agregar tus propias condiciones según tu FSM
    # Por ejemplo, verificar si `L1_out` se activó (bit 3):
    assert dut.uo_out.value[3] == 1, "L1_out debería estar activo"
