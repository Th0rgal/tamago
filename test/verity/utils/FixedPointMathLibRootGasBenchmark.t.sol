// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FixedPointMathLibDeployer} from "../../../src/generated/verity/FixedPointMathLibDeployer.sol";
import {FixedPointMathLibIface} from "../../../src/generated/verity/FixedPointMathLibIface.sol";
import {Test} from "forge-std/Test.sol";

contract FixedPointMathLibRootGasHarness {
    uint256 internal constant ITERS = 1000;

    FixedPointMathLibIface internal immutable lib;

    constructor() {
        lib = FixedPointMathLibDeployer.deploy();
    }

    function benchSqrt(uint256 x) external returns (uint256 raw, uint256 baseline, uint256 net) {
        baseline = _benchBaseline(x);
        raw = _benchSqrt(x);
        net = raw - baseline;
    }

    function benchCbrt(uint256 x) external returns (uint256 raw, uint256 baseline, uint256 net) {
        baseline = _benchBaseline(x);
        raw = _benchCbrt(x);
        net = raw - baseline;
    }

    function _benchBaseline(uint256 x) internal returns (uint256 gasUsed) {
        uint256 acc;
        uint256 start = gasleft();
        for (uint256 i; i < ITERS; ++i) {
            acc ^= x;
        }
        gasUsed = (start - gasleft()) / ITERS;
        assembly {
            pop(acc)
        }
    }

    function _benchSqrt(uint256 x) internal returns (uint256 gasUsed) {
        uint256 acc = lib.sqrt(x);
        uint256 start = gasleft();
        for (uint256 i; i < ITERS; ++i) {
            acc ^= lib.sqrt(x);
        }
        gasUsed = (start - gasleft()) / ITERS;
        assembly {
            pop(acc)
        }
    }

    function _benchCbrt(uint256 x) internal returns (uint256 gasUsed) {
        uint256 acc = lib.cbrt(x);
        uint256 start = gasleft();
        for (uint256 i; i < ITERS; ++i) {
            acc ^= lib.cbrt(x);
        }
        gasUsed = (start - gasleft()) / ITERS;
        assembly {
            pop(acc)
        }
    }
}

contract FixedPointMathLibRootGasBenchmark is Test {
    FixedPointMathLibRootGasHarness internal harness;

    function setUp() public {
        harness = new FixedPointMathLibRootGasHarness();
    }

    function _log(string memory label, uint256 raw, uint256 baseline, uint256 net) internal {
        emit log_named_uint(string.concat(label, " raw"), raw);
        emit log_named_uint(string.concat(label, " baseline"), baseline);
        emit log_named_uint(string.concat(label, " net"), net);
    }

    function _benchSqrt(string memory label, uint256 x) internal {
        (uint256 raw, uint256 baseline, uint256 net) = harness.benchSqrt(x);
        _log(string.concat("sqrt ", label), raw, baseline, net);
    }

    function _benchCbrt(string memory label, uint256 x) internal {
        (uint256 raw, uint256 baseline, uint256 net) = harness.benchCbrt(x);
        _log(string.concat("cbrt ", label), raw, baseline, net);
    }

    function testBenchmarkSqrt0() public {
        _benchSqrt("0", 0);
    }

    function testBenchmarkSqrt1() public {
        _benchSqrt("1", 1);
    }

    function testBenchmarkSqrt2() public {
        _benchSqrt("2", 2);
    }

    function testBenchmarkSqrt255() public {
        _benchSqrt("255", 255);
    }

    function testBenchmarkSqrt256() public {
        _benchSqrt("256", 256);
    }

    function testBenchmarkSqrt1e18() public {
        _benchSqrt("1e18", 1e18);
    }

    function testBenchmarkSqrt2Pow128Minus1() public {
        _benchSqrt("2^128-1", (uint256(1) << 128) - 1);
    }

    function testBenchmarkSqrt2Pow128() public {
        _benchSqrt("2^128", uint256(1) << 128);
    }

    function testBenchmarkSqrtMax() public {
        _benchSqrt("max", type(uint256).max);
    }

    function testBenchmarkCbrt0() public {
        _benchCbrt("0", 0);
    }

    function testBenchmarkCbrt1() public {
        _benchCbrt("1", 1);
    }

    function testBenchmarkCbrt2() public {
        _benchCbrt("2", 2);
    }

    function testBenchmarkCbrt255() public {
        _benchCbrt("255", 255);
    }

    function testBenchmarkCbrt256() public {
        _benchCbrt("256", 256);
    }

    function testBenchmarkCbrt1e18() public {
        _benchCbrt("1e18", 1e18);
    }

    function testBenchmarkCbrt2Pow128Minus1() public {
        _benchCbrt("2^128-1", (uint256(1) << 128) - 1);
    }

    function testBenchmarkCbrt2Pow128() public {
        _benchCbrt("2^128", uint256(1) << 128);
    }

    function testBenchmarkCbrtMax() public {
        _benchCbrt("max", type(uint256).max);
    }
}
