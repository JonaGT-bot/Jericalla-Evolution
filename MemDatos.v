//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module MemoriaDatos (
    input wire [31:0] Address,
    input wire [31:0] DataIn,
    input wire W,
    input wire R,
    output reg [31:0] DataOut
);

    reg [31:0] memory [0:127];
    
    initial
    begin 
	#100
	$readmemb("datosmemoria", memory); 
    end	
    
    always @(*) begin
    if (W && !R) begin
        memory[Address] = DataIn; // Escribimos
    end
    if (R && !W) begin
        DataOut = memory[Address]; // Leemos
    end

    
	else begin
		DataOut = 32'd0;
	end
    end
    endmodule
