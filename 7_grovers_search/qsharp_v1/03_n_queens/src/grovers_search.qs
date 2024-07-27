﻿namespace GroversSearch {
  open Microsoft.Quantum.Arrays;
  open Microsoft.Quantum.Convert;

  operation RunGroversSearch(
    nBits : Int,
    markingOracle : (Qubit[], Qubit) => Unit, 
    prepareMeanOp : Qubit[] => Unit is Adj,
    nIterations : Int
  ) : Bool[] {
    let phaseOracle = ApplyPhaseOracle(_, markingOracle);

    use qs = Qubit[nBits];
    prepareMeanOp(qs);

    for _ in 1 .. nIterations {
      phaseOracle(qs);

      within {
        Adjoint prepareMeanOp(qs);
        ApplyToEachA(X, qs);
      } apply {
        Controlled Z(Rest(qs), qs[0]);
      }
    }

    let meas = MResetEachZ(qs);
    return Mapped(m -> m == One, meas);
  }
  

  operation ApplyPhaseOracle(x : Qubit[], markingOracle : (Qubit[], Qubit) => Unit) : Unit {
    use aux = Qubit();
    within {
      H(aux);
      Z(aux);
    } apply {
      markingOracle(x, aux);
    }
  }
}
