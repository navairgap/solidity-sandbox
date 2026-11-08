// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../src/Counter.sol";

interface Vm {
    struct Log {
        bytes32[] topics;
        bytes data;
        address emitter;
    }

    function recordLogs() external;
    function getRecordedLogs() external returns (Log[] memory);
}

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
    Vm private constant vm = Vm(
        address(uint160(uint256(keccak256("hevm cheat code"))))
    );

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
    function testIncrementEmitsCallerAndValueTransition() external {
        Counter counter = new Counter();
        vm.recordLogs();

        counter.increment();

        Vm.Log[] memory entries = vm.getRecordedLogs();
        require(entries.length == 1, "increment should emit one event");
        require(entries[0].emitter == address(counter), "unexpected event emitter");
        require(entries[0].topics.length == 2, "unexpected event topics");
        require(
            entries[0].topics[0] == keccak256("CountChanged(address,uint256,uint256)"),
            "unexpected event signature"
        );
        require(
            entries[0].topics[1] == bytes32(uint256(uint160(address(this)))),
            "event caller should be the test owner"
        );
        (uint256 previousValue, uint256 newValue) =
            abi.decode(entries[0].data, (uint256, uint256));
        require(previousValue == 0 && newValue == 1, "incorrect event values");
    }


}
