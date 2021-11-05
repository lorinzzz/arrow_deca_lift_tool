# Lift Tool - Proximity and Gensor Alarm (Verilog)

## Functionality
This project realizes a proximity and level sensing alarm using an Arrow Deca FPGA, 4 digit 7Seg hex display, and a DC buzzer. The proximity sensor uses the 3 photo light sensors as a way to measure distance, once the distance is 5 inches and less, the buzzer will beep. The closer the distance, the faster the buzzer will sound. At a distance of zero, the buzzer will be a flat tone. The 7Seg displays will show thw distance. Flipping SW0, we can move over to the level sensor alarm, where the alarm sound if any axis goes above +/- 2. The axis' has a level scaling of 4, where 0 will indicate a level platform. The 7Seg display shows the X level on the left two digits, and the Y level on the right two digits separated by a dot. Flipping SW1 will switch between showing the X or Y axis of the level sensor LED display. Two leds in the middle indicate a level platform. 


Regarding the 7Seg display - The 7seg display is a 4 digit common-cathode LED display, thus a library would need to be written from scratch to show values on the display. It uses a 500Hz derivative clock to refresh the values to enable a persistence of vision. Bit masking is used in each clock cycle to enable each digit. 

Side note: I used 330ohm resistors for slightly lower brightness and to preserve the lifespan of the LEDs 

## Demo
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/59CC9wgQPGw/0.jpg)](https://www.youtube.com/watch?v=59CC9wgQPGw)

## Block Diagram 
<img src="https://i.imgur.com/3VL4AoT.jpg" width="700" />

## Circuit
<img src="https://i.imgur.com/fknnUOJ.jpg" width="700" /> <img src="https://i.imgur.com/choQnrN.jpg" width="400" /> 
<img src="https://i.imgur.com/gY8IqR6.jpgg" width="400" />

