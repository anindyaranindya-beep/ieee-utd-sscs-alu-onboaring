# ALU RTL Design Onboarding Challenge

**32-bit Verilog RTL Arithmetic Logic Unit**

## 1. What Is an ALU?

An **Arithmetic Logic Unit (ALU)** is a digital circuit responsible for performing arithmetic and logical operations on binary data. ALUs are fundamental components of modern processors.

For example, when a processor executes an instruction such as:

* Add two numbers
* Subtract two numbers
* Compare two numbers
* Perform a bitwise AND
* Perform a bitwise OR

the ALU is typically the hardware responsible for carrying out the operation.

An ALU normally receives two input operands and a control signal identifying which operation should be performed. It then produces the result of the operation along with status information about that result.

In this challenge, you will design a **32-bit ALU**.

---

## 2. ALU Interface

Your module must be named:

```verilog
ALU
```

The provided testbench expects the following interface.

### Inputs

| Signal       |   Width | Description                            |
| ------------ | ------: | -------------------------------------- |
| `A`          | 32 bits | First ALU operand                      |
| `B`          | 32 bits | Second ALU operand                     |
| `ALUControl` |  3 bits | Selects which ALU operation to perform |

### Outputs

| Signal     |   Width | Description                                                                   |
| ---------- | ------: | ----------------------------------------------------------------------------- |
| `Result`   | 32 bits | Result of the selected ALU operation                                          |
| `Zero`     |   1 bit | Indicates that `Result` is zero                                               |
| `Negative` |   1 bit | Indicates that `Result` is negative when interpreted as a signed 32-bit value |
| `Overflow` |   1 bit | Indicates signed arithmetic overflow                                          |
| `Carry`    |   1 bit | Indicates an unsigned carry from an arithmetic operation                      |

The module name and port names must match the provided testbench exactly unless the testbench is also modified.

A compatible module declaration will therefore look similar to:

```verilog
module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUControl,
    output [31:0] Result,
    output        Zero,
    output        Negative,
    output        Overflow,
    output        Carry
);

    // Your implementation here

endmodule
```

---

## 3. Required Operations

The provided testbench uses the following `ALUControl` values.

| `ALUControl` | Operation | Description       |
| ------------ | --------- | ----------------- |
| `3'b000`     | ADD       | `A + B`           |
| `3'b001`     | SUB       | `A - B`           |
| `3'b010`     | AND       | Bitwise `A AND B` |
| `3'b011`     | OR        | Bitwise `A OR B`  |
| `3'b101`     | SLT       | Set Less Than     |

Other `ALUControl` combinations are not exercised by the supplied onboarding testbench.

Your implementation should still avoid unintended or undefined behavior when an unsupported control value is received.

---

## 4. Arithmetic Operations

### ADD

When:

```verilog
ALUControl = 3'b000
```

the ALU performs:

```text
A + B
```

For example:

```text
10 + 5 = 15
```

Because this is a 32-bit ALU, only the lower 32 bits of the arithmetic result are available through `Result`.

Arithmetic operations may also affect the `Carry` and `Overflow` flags.

---

### SUB

When:

```verilog
ALUControl = 3'b001
```

the ALU performs:

```text
A - B
```

For example:

```text
10 - 5 = 5
```

If the resulting 32-bit value is negative when interpreted as a signed two's-complement number, the `Negative` flag should indicate this condition.

---

## 5. Logical Operations

### AND

When:

```verilog
ALUControl = 3'b010
```

the ALU performs a bitwise AND operation.

Each bit of `A` is ANDed with the corresponding bit of `B`.

A bit in the result is `1` only when both corresponding input bits are `1`.

Example:

```text
A = 1100
B = 1010
-----------
    1000
```

---

### OR

When:

```verilog
ALUControl = 3'b011
```

the ALU performs a bitwise OR operation.

Each bit of `A` is ORed with the corresponding bit of `B`.

A bit in the result is `1` when at least one of the corresponding input bits is `1`.

Example:

```text
A = 1100
B = 1010
-----------
    1110
```

---

## 6. Set Less Than — SLT

When:

```verilog
ALUControl = 3'b101
```

the ALU performs a **Set Less Than (SLT)** comparison.

For example:

```text
A = 5
B = 10
```

Since:

```text
5 < 10
```

the comparison evaluates as true.

For a conventional 32-bit ALU, a successful SLT operation produces:

```text
Result = 32'h00000001
```

Otherwise:

```text
Result = 32'h00000000
```

Only the least significant bit of `Result` is therefore required to represent the Boolean result of the comparison.

---

## 7. ALU Status Flags

The ALU also produces four status flags:

* `Zero`
* `Negative`
* `Carry`
* `Overflow`

Understanding these flags is an important part of the challenge.

### Zero Flag

`Zero` indicates whether the current ALU result is equal to zero.

```text
Zero = 1 when Result == 0
Zero = 0 otherwise
```

For example:

```text
0 + 0 = 0
```

Therefore:

```text
Zero = 1
```

The flag should describe the **current ALU result**, rather than being hard-coded for any particular test case.

---

### Negative Flag

`Negative` indicates whether `Result` represents a negative value when interpreted as a signed 32-bit two's-complement number.

For a 32-bit signed value, the most significant bit represents the sign.

| Most Significant Bit | Interpretation |
| -------------------- | -------------- |
| `0`                  | Non-negative   |
| `1`                  | Negative       |

For example:

```text
5 - 10 = -5
```

Because the result is negative, the `Negative` flag should be asserted.

---

### Carry Flag

The `Carry` flag represents an **unsigned arithmetic carry**.

Consider:

```text
0xFFFFFFFF + 1
```

The full mathematical result requires 33 bits:

```text
1_00000000
```

A 32-bit `Result` can only store:

```text
0x00000000
```

while the additional bit becomes the carry-out.

Therefore:

```text
Carry = 1
```

The supplied testbench specifically checks this type of condition.

> **Important:** `Carry` and `Overflow` are not the same thing.

`Carry` is primarily associated with **unsigned arithmetic**, while `Overflow` indicates a problem representing the mathematical result as a **signed two's-complement number**.

---

## 8. Signed Overflow

The `Overflow` flag indicates whether the result of a signed arithmetic operation cannot be represented using a signed 32-bit two's-complement number.

The signed 32-bit integer range is:

```text
-2,147,483,648 to +2,147,483,647
```

In hexadecimal:

```text
0x80000000 to 0x7FFFFFFF
```

### Addition Overflow

Consider:

```text
0x7FFFFFFF + 1
```

`0x7FFFFFFF` represents:

```text
+2,147,483,647
```

Adding one should mathematically produce:

```text
+2,147,483,648
```

However, this value cannot be represented as a signed 32-bit integer.

The 32-bit result wraps to:

```text
0x80000000
```

which represents:

```text
-2,147,483,648
```

Therefore, signed overflow has occurred and:

```text
Overflow = 1
```

A useful rule for addition is:

> Adding two operands with the same sign and receiving a result with the opposite sign indicates signed overflow.

---

### Subtraction Overflow

Consider:

```text
0x80000000 - 1
```

`0x80000000` represents:

```text
-2,147,483,648
```

Subtracting one mathematically produces:

```text
-2,147,483,649
```

This value cannot be represented using a signed 32-bit number.

The result therefore wraps around, creating a signed overflow condition.

A useful rule for subtraction is:

> Subtracting operands with different signs can produce overflow when the sign of the result becomes inconsistent with the expected signed mathematical result.

---

## 9. Carry vs. Overflow

The distinction between `Carry` and `Overflow` is extremely important.

| Flag       | Primarily Used For  | Meaning                                                                                |
| ---------- | ------------------- | -------------------------------------------------------------------------------------- |
| `Carry`    | Unsigned arithmetic | Arithmetic generated a bit outside the available 32-bit width                          |
| `Overflow` | Signed arithmetic   | The signed mathematical result cannot be represented within the available 32-bit range |

It is possible for:

* Carry to occur without signed overflow
* Signed overflow to occur without carry
* Both to occur
* Neither to occur

Do **not** treat the two flags as equivalent.

---

## 10. What Is a Testbench?

A **testbench** is verification code used to test a hardware design during simulation.

Unlike synthesizable RTL, a testbench is not intended to become physical hardware. Instead, it creates a controlled simulation environment around the **Design Under Test (DUT)**.

In this challenge:

```text
DUT = ALU
```

The provided testbench:

* Instantiates your `ALU` module
* Connects signals to its inputs and outputs
* Applies predetermined input values
* Selects different ALU operations
* Allows time for outputs to update
* Observes whether the ALU produces the expected behavior
* Checks important arithmetic and status-flag conditions

A successful simulation indicates that your RTL behaves according to the supplied specification for the scenarios exercised by the testbench.

---

## Final Note

> **Do not design your ALU by attempting to memorize or hard-code the expected values of the supplied tests.**

The testbench provides examples of the required behavior.

Your RTL should implement the **underlying ALU functionality** so that the design behaves correctly for other valid input combinations as well.

For example, your design should not contain logic such as:

```verilog
if (A == 32'd10 && B == 32'd5)
    Result = 32'd15;
```

Instead, the ALU should implement the actual arithmetic operation:

```verilog
Result = A + B;
```

The objective of this onboarding challenge is to demonstrate that you can:

* Understand a hardware specification
* Translate that specification into RTL
* Work with arithmetic and logical operations
* Understand common processor status flags
* Simulate and verify a design using a testbench
* Debug RTL when observed behavior differs from expected behavior

**The goal is to design the hardware correctly — not merely to satisfy a small set of specific test vectors.**



