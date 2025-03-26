//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module MemoriaDatos (
    input wire [31:0] Address,
    input wire [31:0] DataIn,
    input wire W,
    input wire R,
    input wire clk,
    output reg [31:0] DataOut
);
    // Aumentamos tamaño, por ejemplo 32
    reg [31:0] memory [0:127];
    
    always @(posedge clk) begin
        if (W) begin
            memory[Address[31:0]] <= DataIn; // Usamos los 32 bits de Address
        end
    end
    
    always @(*) begin
        if (R)
            DataOut = memory[Address[31:0]];
        else
            DataOut = 32'b0;
    end
    integer i;
    initial begin
        for (i=0; i<32; i=i+1)
            memory[i] = 0;
    end

endmodule

