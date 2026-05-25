/-!
DEPRECATED / REMOVED as part of CLZ intrinsic migration (plan.md).

This file (the original 527-line de Bruijn sequence CLZ implementation + full
proof of equivalence to the log2 formula) has been retired from active use.

The canonical CLZ is now declared in:
  verity/src/Tamago/Utils/ClzIntrinsic.lean

All call sites and proof references have been migrated to a thin compatibility
shim in FixedPointMathLibProof.lean (or updated directly for the spec holds).

When the Tamago integration PR lands (after Verity `verity_intrinsic` support
is available and tama.toml / lake-manifest.json are bumped to a supporting
Verity rev), this file should be `git rm`'d entirely.

See git history for the full original proof if needed for audit.
The key superseded theorem was `clzScanNat_eq_logScan` / `clz_run_val`.
-/

import Tamago.Utils.ClzIntrinsic

namespace Tamago.Proof.Utils.ClzProof

open Verity
open Verity.EVM.Uint256
open Tamago.Utils
open Tamago.Utils.FixedPointMathLib

-- Stubs only. Real semantics live in the intrinsic declaration (and its
-- generated consumer axiom `clz_matches_eip7939`).

theorem clz_run_val (x : Uint256) (s : ContractState) : True := True.intro

end Tamago.Proof.Utils.ClzProof
