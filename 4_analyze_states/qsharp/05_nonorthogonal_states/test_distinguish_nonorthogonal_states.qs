namespace AnalyzeStates.Test {
  open Microsoft.Quantum.Convert;
  open Microsoft.Quantum.Diagnostics;
  open Microsoft.Quantum.Intrinsic;
  open Microsoft.Quantum.Math;
  open Microsoft.Quantum.Random;
  open AnalyzeStates;

  operation PrepInputState(q : Qubit, alpha : Double, beta : Double, ind : Int) : Unit {
    if ind == 1 {
      Ry(2. * ArcTan2(beta, alpha), q);
    }
  }

  @Test("QuantumSimulator")
  operation TestDistinguishZeroAndSup() : Unit {
    for _ in 1 .. 10 {
      let angle = DrawRandomDouble(0., PI() / 2.);
      let (alpha, beta) = (Cos(angle), Sin(angle));
      mutable nCorrect = 0;
      let nTrials = 1000;
      for _ in 1 .. nTrials {
        use q = Qubit();
        let stateInd = DrawRandomInt(0, 1);
        PrepInputState(q, alpha, beta, stateInd);
        let resState = DistinguishZeroAndSup(q, alpha, beta);
        if resState == stateInd {
          set nCorrect += 1;
        }
      }
      let pSuccess = IntAsDouble(nCorrect) / IntAsDouble(nTrials);
      let pSuccessTheor = 0.5 * (1. + Sqrt(1. - alpha ^ 2.));
      Message($"Correct guesses {pSuccess}, theoretical {pSuccessTheor}");
      if pSuccess < pSuccessTheor - 0.05 {
        fail $"Expected success probability {pSuccessTheor}, got {pSuccess}, too low";
      }
      if pSuccess > pSuccessTheor + 0.05 {
        fail $"Expected success probability {pSuccessTheor}, got {pSuccess}, too high";
      }
    }
  }
}