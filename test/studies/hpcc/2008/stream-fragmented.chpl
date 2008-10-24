use Time, Types, Random;
use hpccMultilocale;

use HPCCProblemSize;


param numVectors = 3;
type elemType = real(64),
     indexType = int(64);

config const m = computeProblemSize(numVectors, elemType),
             alpha = 3.0;

config const numTrials = 10,
             epsilon = 0.0;

config const useRandomSeed = true,
             seed = if useRandomSeed then SeedGenerator.clockMS else 314159265;

config const printParams = true,
             printArrays = false,
             printStats = true;


def main() {
  printConfiguration();

  const ProblemSpace: domain(1, indexType) = [1..m];

  var localGBs: [LocaleSpace] real,
      allValidAnswer: [LocaleSpace] bool;
  
  coforall loc in Locales {
    on loc {
      const myProblemSpace: domain(1, indexType)
                          = BlockPartition(ProblemSpace, here.id, numLocales);

      var myA, myB, myC: [myProblemSpace] elemType;

      initVectors(myB, myC, myProblemSpace);

      const localTimings: [1..numTrials] real;

      for trial in 1..numTrials {
        const startTime = getCurrentTime();
        local {
	forall (a, b, c) in (myA, myB, myC) do
	  a = b + alpha * c;
        }
        localTimings(trial) = getCurrentTime() - startTime;
      }

      const myMinTime = min reduce localTimings;

      localGBs(here.id) = numVectors * numBytes(elemType) * (m / myMinTime) * 1e-9;
      allValidAnswer(here.id) = verifyResults(myA, myB, myC);
    }
  }

  const minGBs = min reduce localGBs,
        maxGBs = max reduce localGBs,
        avgGBs = + reduce localGBs / numLocales;

  const validAnswer = & reduce allValidAnswer;

  printResults(validAnswer, minGBs, avgGBs, maxGBs);
}


def printConfiguration() {
  if (printParams) {
    printProblemSize(elemType, numVectors, m);
    writeln("Number of trials = ", numTrials, "\n");
  }
}


def initVectors(B, C, ProblemSpace) {
  var randlist = new RandomStream(seed);

  randlist.skipToNth(B.domain.low);
  randlist.fillRandom(B);
  randlist.skipToNth(ProblemSpace.numIndices + C.domain.low);
  randlist.fillRandom(C);

  if (printArrays) {
    writelnFragArray("B is: ", B, "\n");
    writelnFragArray("C is: ", C, "\n");
  }
}


def verifyResults(A, B, C) {
  if (printArrays) then writelnFragArray("A is: ", A, "\n");

  const infNorm = max reduce [i in A.domain] abs(A(i) - (B(i) + alpha * C(i)));

  return (infNorm <= epsilon);
}


def printResults(successful, minGBs, avgGBs, maxGBs) {
  writeln("Validation: ", if successful then "SUCCESS" else "FAILURE");
  if (printStats) {
    writeln("Fragmented, per-locale GBs:");
    writeln("  min = ", minGBs);
    writeln("  avg = ", avgGBs);
    writeln("  max = ", maxGBs);
  }
}
