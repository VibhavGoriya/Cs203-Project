`timescale 1ns / 1ps
module password_parking_system( 
                input Clk,Reset,
 input enter_sensor, exit_sensor, 
 input [1:0] Password_1, Password_2,
 output wire Led_Green,Led_Red,
 output reg [6:0] Hex1, Hex2
    );
 parameter Idle = 3'b000, 
  WaitPass = 3'b001,
  WrongPass = 3'b010,
  RightPass = 3'b011,
  STOP = 3'b100;
  
 reg[2:0] CurrentState, Next;
 reg[31:0] WaitCounter;
 reg red,green;
  // This is a Moore Fsm model where output just depends on current state
  
  
  // Next state can be set as
 always @(posedge Clk or negedge Reset)
 begin
 if(~Reset) 
 CurrentState = Idle;
 else
 CurrentState = Next;
 end
 
  

  // Setting up Wait Counter
  always @(posedge Clk or negedge Reset) 
 begin
 if(~Reset) 
 WaitCounter <= 0;
 else if(CurrentState==WaitPass)
 WaitCounter <= WaitCounter + 1;
 else 
 WaitCounter <= 0;
 end
 
  // For Changing states:

 always @(*)
 begin
 case(CurrentState)
 Idle: begin
         if(enter_sensor == 1)
 Next = WaitPass;
 else
 Next = Idle;
 end
 WaitPass: begin
   if(WaitCounter <= 3)//.If there is a vehicle coming detected by the enter 								sensor, State is switched to Wait for 4 cycles.
 Next = WaitPass;
 else 
 begin
 if((Password_1==2'b01)&&(Password_2==2'b10))
 Next = RightPass;
 else
 Next = WrongPass;
 end
 end
 WrongPass: begin
 if((Password_1==2'b01)&&(Password_2==2'b10))
 Next = RightPass;
 else
 Next = WrongPass;
 end
 RightPass: begin
 if(enter_sensor==1 && exit_sensor == 1)
 Next = STOP;
 else if(exit_sensor == 1)
 Next = Idle;
 else
 Next = RightPass;
 end
 
   STOP: begin
 if((Password_1==2'b01)&&(Password_2==2'b10))
 Next = RightPass;
 else
 Next = STOP;
 end
 default: Next = Idle;
 endcase
 end
 // Observing Led's and Output
 always @(posedge Clk) begin 
 case(CurrentState)
 
  Idle: begin
 green = 1'b0;
 red = 1'b0;
 Hex1 = 7'b1111111; 
 Hex2 = 7'b1111111; 
 end
   
//The car will input the password in this state
 WaitPass: begin
 green = 1'b0;
 red = 1'b1;
 Hex1 = 7'b000_0110;
 Hex2 = 7'b010_1011;
 end
   
   
 WrongPass: begin
 green = 1'b0;
 red = ~red;
 Hex1 = 7'b000_0110; 
 Hex2 = 7'b000_0110;  
 end
   
 RightPass: begin
 green = ~green;
 red = 1'b0;
 Hex1 = 7'b000_0010;
 Hex2 = 7'b100_0000; 
 end
  // If the password is correct, the gate is opened to let the car get in the car park and state turns to Right,
// Green LED will start blinking.  

   
   STOP: begin
 green = 1'b0;
 red = ~red;
 Hex1 = 7'b001_0010;
 Hex2 = 7'b000_1100; 
   //Otherwise, state turns to Wrong, a Red LED will start blinking and it requires the car to enter the password again until the password is correct.
 end
 	endcase
 end
 assign Led_Red = red  ;
 assign Led_Green = green;

endmodule
