//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module JericallaEvo(
    input [16:0] INST,
    input CLK,
    output [31:0] DataOut
);

    // Buffers para direcciones
    wire [4:0] WaBuf1, WaBuf2;
    // Banco de Registros
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ReadData1Buf1, ReadData2Buf1;
    wire [31:0] ReadData1Demux, ReadData2Demux;
    wire [31:0] ReadData1Buf2, ReadData2Buf2;
    // Control
    wire WriteEnable, DemuxSelect, MemWrite, MemRead;
    wire [1:0] AluMode;
    wire [1:0] AluModeBuf1;
    wire WriteEnableBuf1, DemuxSelectBuf1, MemWriteBuf1, MemReadBuf1;
    wire WriteEnableBuf2, MemWriteBuf2, MemReadBuf2;
    // Buffer intermedio
    wire [76:0] BufferComb1;
    wire [76:0] BufferOut1;
    wire [103:0] BufferComb2;
    wire [103:0] BufferOut2;
    // Demultiplexores
    wire [31:0] DemuxOut1, DemuxOut2;
    // ALU
    wire [31:0] AluResult;
    wire [31:0] AluResultBuf2;

    // Instancia del Control
    Control ControlUnit (
        .OpCode(INST[16:15]),
        .WE(WriteEnable),
        .AluOp(AluMode),
        .Demux(DemuxSelect),
        .W(MemWrite),
        .R(MemRead)
    );

    // Instancia al Banco de Registros
    BancoRegistros RegisterBank (
        .RA1(INST[9:5]),
        .RA2(INST[4:0]),
        .WA(INST[14:10]),
        .WD(AluResultBuf2),
        .WE(WriteEnableBuf2),
        .clk(CLK),
        .DR1(ReadData1),
        .DR2(ReadData2)
    );

    // Instancias de los Demux
    Demux Demux1 (
        .In(ReadData1Buf1),
        .op(DemuxSelectBuf1),
        .OutAlu(DemuxOut1),
        .OutBuffer(ReadData1Demux)
    );

    Demux Demux2 (
        .In(ReadData2Buf1),
        .op(DemuxSelectBuf1),
        .OutAlu(DemuxOut2),
        .OutBuffer(ReadData2Demux)
    );

    // Instancia de la ALU
    Alu ALU(
        .A(DemuxOut1),
        .B(DemuxOut2),
        .OP(AluModeBuf1),
        .Res(AluResult)
    );

    // Instancia de la Memoria de Datos
    MemoriaDatos DataMemory (
        .Address(ReadData1Buf2),
        .DataIn(ReadData2Buf2),
        .W(MemWriteBuf2),
        .R(MemReadBuf2),
        .DataOut(DataOut)
    );

    // Se pasan los datos atraves del buffer 1
    assign BufferComb1 = {INST[14:10], WriteEnable, DemuxSelect, MemWrite, MemRead, AluMode, ReadData1, ReadData2};
    BF#(77) Buffer1 (
        .in(BufferComb1),
        .clk(CLK),
        .out(BufferOut1)
    );

    assign WaBuf1  = BufferOut1[76:72];
    assign WriteEnableBuf1 = BufferOut1[71];
    assign DemuxSelectBuf1 = BufferOut1[70];
    assign MemWriteBuf1 = BufferOut1[69];
    assign MemReadBuf1 = BufferOut1[68];
    assign AluModeBuf1 = BufferOut1[67:66];
    assign ReadData1Buf1 = BufferOut1[65:34];
    assign ReadData2Buf1 = BufferOut1[33:2];

    // Ahora pasamos los datos por el buffer 2
    assign BufferComb2 = {WaBuf1, WriteEnableBuf1, MemWriteBuf1, MemReadBuf1, AluResult, ReadData1Demux, ReadData2Demux};
    BF#(104) Buffer2 (
        .in(BufferComb2),
        .clk(CLK),
        .out(BufferOut2)
    );

    assign WaBuf2 = BufferOut2[103:99];
    assign WriteEnableBuf2 = BufferOut2[98];
    assign MemWriteBuf2 = BufferOut2[97];
    assign MemReadBuf2 = BufferOut2[96];
    assign AluResultBuf2 = BufferOut2[95:64];
    assign ReadData1Buf2 = BufferOut2[63:32];
    assign ReadData2Buf2 = BufferOut2[31:0];

endmodule


module JericallaTB();
reg [16:0] INST;
reg CLK;
wire [31:0] DataOut;

parameter instrucciones = 6;

reg [16:0] memoryInst [0:instrucciones-1];

JericallaEvo testbench (.INST(INST),.CLK(CLK),. DataOut(DataOut));

 integer i;
 
//Inicializa el reloj
initial begin
    CLK = 0;
    forever #100 CLK = ~CLK;
end

initial begin	
    #1000;
    // Cargamos el archivo que nos da python
    $readmemb("pythonDB", memoryInst);
	
    for (i = 0; i < instrucciones; i = i + 1) begin
      INST = memoryInst[i];
      #1000;
    end
    
    $stop;
  end
  
endmodule