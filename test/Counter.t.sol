// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../src/Counter.sol";

contract NonOwnerActor {
    function tryIncrement(Counter counter) external returns (bool success) {
        (success, ) = address(counter).call(
            abi.encodeWithSelector(Counter.increment.selector)
        );
    }

    function tryReset(Counter counter) external returns (bool success) {
        (success, ) = address(counter).call(
            abi.encodeWithSelector(Counter.reset.selector)
        );
    }
}

/// @dev Uses plain require/assert so the first exercise has no external test dependency.
contract CounterTest {
    function testOwnerCanIncrementAndReset() external {
        Counter counter = new Counter();
        require(counter.owner() == address(this), "test contract should own counter");
        require(counter.count() == 0, "initial count should be zero");
        require(counter.increment() == 1, "increment should return new count");
        require(counter.count() == 1, "count should increment");
        counter.reset();
        require(counter.count() == 0, "reset should clear count");
    }

    function testNonOwnerCannotIncrement() external {
        Counter counter = new Counter();
        NonOwnerActor actor = new NonOwnerActor();
        require(!actor.tryIncrement(counter), "non-owner increment unexpectedly succeeded");
        require(counter.count() == 0, "rejected increment changed state");
    }

    function testNonOwnerCannotReset() external {
        Counter counter = new Counter();
        counter.increment();
        NonOwnerActor actor = new NonOwnerActor();
        require(!actor.tryReset(counter), "non-owner reset unexpectedly succeeded");
        require(counter.count() == 1, "rejected reset changed state");
    }
}
