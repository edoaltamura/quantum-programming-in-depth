from qiskit import QuantumCircuit
from qiskit.circuit.library.standard_gates import XGate

def oracle_negation():
  circ = QuantumCircuit(2)
  circ.cx(0, 1)
  circ.x(1)
  return circ

def oracle_xor():
  circ = QuantumCircuit(3)
  circ.cx(0, 2)
  circ.cx(1, 2)
  return circ

def oracle_and():
  circ = QuantumCircuit(3)
  circ.ccx(0, 1, 2)
  return circ

def oracle_or():
  circ = QuantumCircuit(3)
  circ.x(0)
  circ.x(1)
  circ.ccx(0, 1, 2)
  circ.x(0)
  circ.x(1)
  circ.x(2)
  return circ

def oracle_equal():
  circ = QuantumCircuit(3)
  circ.cx(0, 1)
  circ.cx(1, 2)
  circ.cx(0, 1)
  circ.x(2)
  return circ

def oracle_multiand(n):
  circ = QuantumCircuit(n + 1)
  circ.append(XGate().control(n), range(n + 1))
  return circ

def oracle_multior(n):
  circ = QuantumCircuit(n + 1)
  circ.append(XGate().control(n, ctrl_state=0), range(n + 1))
  circ.x(n)
  return circ
