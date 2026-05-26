# Tamago — Consumer Axioms

This file registers axioms that Tamago introduces via Verity's `verity_intrinsic`
mechanism (see plan.md and Verity's `docs/INTRINSICS.md` once available).

Verity itself ships with **zero project-level axioms**. All axioms produced by
intrinsics live in the **consumer's namespace** and are auditable via
`--trust-report`.

## CLZ (EIP-7939) Intrinsic

Declared in: `verity/common/Tamago/Common/ClzIntrinsic.lean`

```lean
verity_intrinsic clz (x : Uint256) : Uint256 where
  pure
  yul := verbatim 1 1 (hex "1e")
  min_fork := fusaka
  semantics := fun x => ofNat (if x.toNat = 0 then 256 else 255 - Nat.log2 x.toNat)
  obligation [clz_matches_eip7939 :=
    assumed "EIP-7939 CLZ opcode; chain must be Fusaka+"]
```

**Generated axiom marker (consumer namespace):**
- `Tamago.Common.ClzIntrinsic.clz_matches_eip7939`

**Trust surface (one line):**
- The EVM executing the deployed bytecode must implement EIP-7939 CLZ
  (opcode 0x1e) with the documented semantics.
- The chain must be at or past the Fusaka hard fork (enforced at link time
  by Verity unless `--allow-future-fork-intrinsics` is passed).

**Upgrade path:**
When EVMYulLean models CLZ natively, Verity can derive the same semantics
from the opcode model. The `assumed` obligation becomes `proved` automatically;
no change to Tamago source or proofs is required.

## Relationship to Verity policy

See Verity:
- `AXIOMS.md` (stays at "0 project-level axioms")
- `TRUST_ASSUMPTIONS.md` § "Trusted Intrinsics"
- `AUDIT.md` (row for `trust_report.intrinsics[*]`)
- `docs/INTRINSICS.md` (when published)

All Tamago mirror tests and proofs that depend on `clz` (sqrt, cbrt, and the
two direct `clz_*` specs) are discharged using the intrinsic semantics (or the
migration shim that exactly matches it).

## Baseline gas (pre-intrinsic)

See `test/verity/utils/FixedPointMathLibRootGasBenchmark.t.sol` and the
benchmark numbers captured on `codex/tamago-clz-intrinsic` before the source
change. Post-intrinsic rerun is expected to show the ~200 gas/call improvement
from removing the de Bruijn sequence + table + 8–9 extra ops per root.
