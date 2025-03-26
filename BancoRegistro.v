//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module BancoRegistros (
    input wire [4:0] RA1,    
    input wire [4:0] RA2,    
    input wire [4:0] WA,     
    input wire [31:0] WD,    
    input wire WE,           
    input wire clk,
    output wire [31:0] DR1,  
    output wire [31:0] DR2   
);
    
    reg [31:0] registro [0:31];
    
    // Carga inicial de datos
    initial begin
        $readmemb("datos", registro); // Leer valores en binario
    end

    assign DR1 = registro[RA1];
    assign DR2 = registro[RA2];
    
    always @(posedge clk) begin
        if (WE)
            registro[WA] <= WD;
    end
endmodule