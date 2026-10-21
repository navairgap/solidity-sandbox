# contract test checklist

Use a local development chain and never real funds for teaching exercises. Test authorized and unauthorized callers, boundary values, events and state changes, malicious receiver reentrancy, failed external calls, pause and ownership recovery paths, and accounting invariants. Review static-analysis warnings rather than treating tools as guarantees. Pair every vulnerable teaching example with a corrected implementation and regression test.
