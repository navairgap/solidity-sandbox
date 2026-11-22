// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../src/Vault.sol";

interface Vm {
    struct Log {
        bytes32[] topics;
        bytes data;
        address emitter;
    }

    function deal(address account, uint256 newBalance) external;
    function recordLogs() external;
    function getRecordedLogs() external returns (Log[] memory);
}

contract RejectingVaultActor {
    function deposit(Vault vault) external payable {
        vault.deposit{value: msg.value}();
    }

    function tryWithdraw(Vault vault, uint256 amount) external returns (bool success, bytes memory returnData) {
        (success, returnData) = address(vault).call(abi.encodeWithSelector(Vault.withdraw.selector, amount));
    }

    receive() external payable {
        revert("reject payout");
    }
}

contract ReentrantVaultActor {
    Vault public vault;
    uint256 public withdrawalAmount;
    uint256 public callbackCount;
    bool public nestedCallSucceeded;
    bytes public nestedReturnData;

    function deposit(Vault target) external payable {
        vault = target;
        vault.deposit{value: msg.value}();
    }

    function startWithdraw(uint256 amount) external {
        withdrawalAmount = amount;
        vault.withdraw(amount);
    }

    receive() external payable {
        callbackCount++;
        (nestedCallSucceeded, nestedReturnData) =
            address(vault).call(abi.encodeWithSelector(Vault.withdraw.selector, withdrawalAmount));
    }
}

contract VaultTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    receive() external payable {}

    function testDepositTracksUserAndTotal() external {
        Vault vault = new Vault();
        vm.deal(address(this), 2 ether);

        vault.deposit{value: 1 ether}();

        require(vault.balances(address(this)) == 1 ether, "user balance should increase");
        require(vault.totalDeposits() == 1 ether, "total deposits should increase");
        require(address(vault).balance == 1 ether, "vault should hold deposited ether");
    }

    function testWithdrawTransfersValueAndUpdatesAccounting() external {
        Vault vault = new Vault();
        vm.deal(address(this), 2 ether);
        vault.deposit{value: 1 ether}();

        vault.withdraw(0.4 ether);

        require(vault.balances(address(this)) == 0.6 ether, "user balance should decrease");
        require(vault.totalDeposits() == 0.6 ether, "total deposits should decrease");
        require(address(vault).balance == 0.6 ether, "vault should retain the remaining ether");
    }

    function testDepositRejectsZeroValue() external {
        Vault vault = new Vault();

        (bool success, bytes memory returnData) = address(vault).call(abi.encodeWithSelector(Vault.deposit.selector));

        require(!success, "zero-value deposit unexpectedly succeeded");
        require(
            keccak256(returnData) == keccak256(abi.encodeWithSelector(Vault.ZeroAmount.selector)),
            "deposit should return ZeroAmount"
        );
    }

    function testWithdrawRejectsZeroAmount() external {
        Vault vault = new Vault();

        (bool success, bytes memory returnData) = address(vault).call(
            abi.encodeWithSelector(Vault.withdraw.selector, 0)
        );

        require(!success, "zero withdrawal unexpectedly succeeded");
        require(
            keccak256(returnData) == keccak256(abi.encodeWithSelector(Vault.ZeroAmount.selector)),
            "withdrawal should return ZeroAmount"
        );
    }

    function testWithdrawAboveBalanceRevertsWithoutChangingAccounting() external {
        Vault vault = new Vault();
        vm.deal(address(this), 2 ether);
        vault.deposit{value: 1 ether}();

        uint256 requested = 1 ether + 1;
        (bool success, bytes memory returnData) = address(vault).call(
            abi.encodeWithSelector(Vault.withdraw.selector, requested)
        );

        bytes memory expectedError =
            abi.encodeWithSelector(Vault.InsufficientBalance.selector, address(this), requested, 1 ether);
        require(!success, "withdrawal above balance unexpectedly succeeded");
        require(keccak256(returnData) == keccak256(expectedError), "incorrect insufficient-balance error");
        require(vault.balances(address(this)) == 1 ether, "failed withdrawal changed user balance");
        require(vault.totalDeposits() == 1 ether, "failed withdrawal changed total deposits");
        require(address(vault).balance == 1 ether, "failed withdrawal moved ether");
    }

    function testFailedPayoutRestoresAccounting() external {
        Vault vault = new Vault();
        RejectingVaultActor actor = new RejectingVaultActor();
        vm.deal(address(actor), 1 ether);
        actor.deposit{value: 1 ether}(vault);

        (bool success, bytes memory returnData) = actor.tryWithdraw(vault, 1 ether);

        require(!success, "rejecting receiver unexpectedly withdrew");
        require(
            keccak256(returnData) == keccak256(abi.encodeWithSelector(Vault.TransferFailed.selector)),
            "failed payout should return TransferFailed"
        );
        require(vault.balances(address(actor)) == 1 ether, "failed payout should restore user balance");
        require(vault.totalDeposits() == 1 ether, "failed payout should restore total deposits");
        require(address(vault).balance == 1 ether, "failed payout should leave ether in the vault");
    }

    function testReentrantCallbackCannotWithdrawTwice() external {
        Vault vault = new Vault();
        ReentrantVaultActor actor = new ReentrantVaultActor();
        vm.deal(address(this), 1 ether);
        actor.deposit{value: 1 ether}(vault);

        actor.startWithdraw(1 ether);

        bytes memory expectedNestedError =
            abi.encodeWithSelector(Vault.InsufficientBalance.selector, address(actor), 1 ether, 0);
        require(actor.callbackCount() == 1, "receiver callback should run once");
        require(!actor.nestedCallSucceeded(), "nested withdrawal unexpectedly succeeded");
        require(
            keccak256(actor.nestedReturnData()) == keccak256(expectedNestedError),
            "nested withdrawal should observe the reduced balance"
        );
        require(vault.balances(address(actor)) == 0, "withdrawn balance should be zero");
        require(vault.totalDeposits() == 0, "total deposits should be zero after withdrawal");
        require(address(vault).balance == 0, "vault should not retain withdrawn ether");
        require(address(actor).balance == 1 ether, "receiver should receive only the original withdrawal");
    }

    function testDepositAndWithdrawEmitExpectedEvents() external {
        Vault vault = new Vault();
        vm.deal(address(this), 2 ether);

        vm.recordLogs();
        vault.deposit{value: 1 ether}();
        _assertVaultEvent(vault, keccak256("Deposited(address,uint256,uint256)"), 1 ether, 1 ether);

        vm.recordLogs();
        vault.withdraw(0.4 ether);
        _assertVaultEvent(vault, keccak256("Withdrawn(address,uint256,uint256)"), 0.4 ether, 0.6 ether);
    }

    function _assertVaultEvent(Vault vault, bytes32 signature, uint256 amount, uint256 newBalance) private {
        Vm.Log[] memory entries = vm.getRecordedLogs();
        require(entries.length == 1, "operation should emit one event");
        require(entries[0].emitter == address(vault), "unexpected event emitter");
        require(entries[0].topics.length == 2, "unexpected event topics");
        require(entries[0].topics[0] == signature, "unexpected event signature");
        require(
            entries[0].topics[1] == bytes32(uint256(uint160(address(this)))), "event account should be the test owner"
        );

        (uint256 emittedAmount, uint256 emittedBalance) = abi.decode(entries[0].data, (uint256, uint256));
        require(emittedAmount == amount && emittedBalance == newBalance, "incorrect event values");
    }
}
