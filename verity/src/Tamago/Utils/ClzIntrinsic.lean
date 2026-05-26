import Contracts.Common

/-!
CLZ (count leading zeros) intrinsic for Tamago.

This replaces the previous 527-line de Bruijn sequence software implementation
and its proof (ClzProof.lean) with a direct binding to the EIP-7939 CLZ opcode
(via Verity `verity_intrinsic`).

The trust assumption is explicit and consumer-namespaced:
- `Tamago.Utils.ClzIntrinsic.clz_matches_eip7939`

When EVMYulLean upstream models CLZ (post-fork), this can be upgraded from
`assumed` to `proved` with no change to this declaration site.
-/

namespace Tamago.Utils.ClzIntrinsic

open Verity
open Verity.EVM.Uint256

def clzLowering : Verity.Core.Intrinsics.YulLowering :=
  .verbatim 1 1 "1e"

verity_intrinsic clz (x : Uint256) : Uint256 where pure; yul := verbatim 1 1 (hex "1e"); min_fork := fusaka; semantics := (fun x => Verity.Core.Uint256.ofNat (if x.val = 0 then 256 else 255 - Nat.log2 x.val)); obligation [clz_matches_eip7939 := assumed "EIP-7939 CLZ opcode; chain must be Fusaka+"]

macro_rules
  | `(intrinsic "clz" $_lowering:term [ $arg:term ]) =>
      `(Tamago.Utils.ClzIntrinsic.clz $arg)

end Tamago.Utils.ClzIntrinsic
