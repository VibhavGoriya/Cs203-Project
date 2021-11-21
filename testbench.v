`timescale 1ns / 1ps


module tb_password_parking_system;

  // Inputs
  reg Clk=1'b0;
  reg Reset;
  reg enter_sensor;
  reg exit_sensor;
  reg [1:0] Password_1;
  reg [1:0] Password_2;
  
  // Outputs
  wire Led_Green;
  wire Led_Red;
  wire [6:0] Hex1;
  wire [6:0] Hex2;

  password_parking_system uut (
  .Clk(Clk), 
  .Reset(Reset), 
  .enter_sensor(enter_sensor), 
  .exit_sensor(exit_sensor), 
  .Password_1(Password_1), 
  .Password_2(Password_2), 
  .Led_Green(Led_Green), 
  .Led_Red(Led_Red), 
  .Hex1(Hex1), 
    .Hex2(Hex2)
    
 );

initial
  begin
    Clk=1'b0;
    forever
      #10 Clk=!Clk;
    end
  
  
  //Observing Inputs and Led's after every 20ns
  initial
  begin
    
    forever
      #20 $display("Inputs--Sensor.enter: %b,Sensor.exit: %b   Outputs-- Green Led: %b,Red Led: %b",enter_sensor,exit_sensor,Led_Green,Led_Red);
    	
    end
  
  
 //Finishing the observations at 10000ns  
  initial
  begin
    #10000 $finish;
  end
  
 initial begin
 // Initializing Inputs
 Reset = 0;
 enter_sensor = 0;
 exit_sensor = 0;
 Password_1 = 0;
 Password_2 = 0;
 
   Reset = 1;
 #100;
 enter_sensor = 1;
 #1000;
 enter_sensor = 0;
 Password_1 = 1;
 Password_2 = 2;
 #2000;
 exit_sensor =1;
 
 

 end 
initial begin
  $dumpfile("parking.vcd");
  $dumpvars(1);
end

      
endmodule