`timescale 1ns / 1ps

module barrel_tb();
    reg [31:0]a;
    reg [7:0] cmd;
    wire [31:0] o;
    wire [31:0] corr;
    wire error;
    integer file;
    integer i;
 
barrel uut (a, cmd, o);

initial begin
    file = $fopen("test_data.txt", "r");

    for (i = 0; i < 16; i = i + 1) begin
        $fscanf(file, "%h %h %h\n", a, cmd, corr);
        #20; 
    end

    $fclose(file);
    $finish;
end

assign error = (o == corr);

endmodule
