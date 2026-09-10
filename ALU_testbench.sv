`timescale 1ns/1ps

module ALU_tb;

    // declaring inputs
    reg [31:0] A, B;
    reg [2:0] ALUControl;
    
    // declaring outputs
    wire [31:0] Result;
    wire Zero, Negative, Overflow, Carry;
    
    // instantiating ALU module
    ALU dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );
    
    // test logic
    initial begin
    
        // TEST 1 - ADD operation with zero result
        A = 32'd0;
        B = 32'd0;
        ALUControl = 3'b000;
        
        #10;
        
        
        // TEST 2 - ADD operation
        A = 32'd10;
        B = 32'd5;
        ALUControl = 3'b000;
        
        #10;
        
        
        // TEST 3 - ADD operation with carry
        A = 32'hFFFFFFFF;
        B = 32'd1;
        ALUControl = 3'b000;
        
        #10;
        
        
        // TEST 4 - ADD operation with overflow
        A = 32'h7FFFFFFF;
        B = 32'd1;
        ALUControl = 3'b000;
        
        #10;
        
        
        // TEST 5 - SUB operation
        A = 32'd10;
        B = 32'd5;
        ALUControl = 3'b001;
        
        #10;
        
        
        // TEST 6 - SUB operation with negative result
        A = 32'd5;
        B = 32'd10;
        ALUControl = 3'b001;
        
        #10;
        
        
        // TEST 7 - SUB operation with overflow
        A = 32'h80000000;
        B = 32'd1;
        ALUControl = 3'b001;
        
        #10;
        
        
        // TEST 8 - AND operation
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALUControl = 3'b010;
        
        #10;
        
        
        // TEST 9 - OR operation
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALUControl = 3'b011;
        
        #10;
        
        
        // TEST 10 - SLT operation
        A = 32'd5;
        B = 32'd10;
        ALUControl = 3'b101;
        
        #10;
        
        
        // ending simulation
        $finish;
        
    end

endmodule
