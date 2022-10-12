# msp430FR2355_matrix_keypad

pinout 

Rows=P5 BIT0-BIT3
Cols=P1 BIT2-BIT5

![image](https://user-images.githubusercontent.com/100885922/182289813-ac452284-f1ec-487b-b62e-b85bb0f00453.png)
1-4 = cols, 5-8 rows

P5 BIT0    4
P5 BIT1    3
P5 BIT1    2
P5 BIT1    1

P1 BIT2    8
P1 BIT3    7
P1 BIT4    6
P1 BIT5    5



usage

subroutine: init_pins sets up all pins 
initially all column pins (P1) are set as inputs and held low and each are enabled as interrupt hight/low with pull up resistor set
all rows pins (P5) are set as outputs and held high 

ISR: get_input: interrupt service routine to get row and column pressed
only one row and column can be determined per interrupt. 
**ISR will disable interrupts for all inputs so init_pins will need to be called to reset**
getting row/col

row and cols are stored as static members from .asm file and can be externed if using C. 
