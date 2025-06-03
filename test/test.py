import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge
from cocotb.result import TestFailure

@cocotb.test()
async def test_fsm_basic(dut):
    """Test básico para la FSM"""

    # Configurar reloj
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset inicial activo
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1  # Desactivar reset
    dut.ena.value = 1

    # Esperar varios ciclos para estabilizar
    for _ in range(10):
        await RisingEdge(dut.clk)

    # Prueba: poner S=1, L1=L2=L3=0
    dut.ui_in.value = 0b00000001
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    # Leer estados internos (salidas)
    s0 = dut.uo_out.value.integer & 0xFF

    # Mostrar en consola
    dut._log.info(f"Salida uo_out: {s0:08b}")

    # Chequear que no esté en estado reset (X0=0, X1=0)
    if (s0 & 0x3) == 0:
        raise TestFailure("FSM está en estado 00 tras poner S=1. Se esperaba cambio de estado")

    # Prueba combinando otros valores de entrada
    # Por ejemplo: S=0, L1=1, L2=0, L3=1 -> 0b00001100 (bit1=L1, bit3=L3)
    dut.ui_in.value = 0b00001100
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    s1 = dut.uo_out.value.integer & 0xFF
    dut._log.info(f"Salida uo_out (L1=1,L3=1): {s1:08b}")

    # No esperamos valores exactos, solo que la FSM cambia estado
    if s1 == s0:
        raise TestFailure("FSM no cambio estado tras cambiar inputs")

    # Finalizar
    dut.ena.value = 0
    await RisingEdge(dut.clk)
