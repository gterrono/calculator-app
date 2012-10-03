Calculator App
==============
A simple calculator iPhone app written for CIS 195.
It allows multiplication, division, subraction and addition of numbers.
I implemented the UI just with a grid of buttons and a label for output.
In order to support calculations, I kept track of an array of numbers and operations in the order that the user inputted them.
I also kept track of the display text seperately so that I wouldn't have to compile the array over and over again.
I disabled buttons that would cause bad input, so that no invalid input should be allowed to be even typed (besides division by 0)


Some Things to Note
-------------------
* Numbers < 1 and > 0 need to start with a "0."
* The app dynamically disables buttons (shown by greying out the buttons) that would cause invalid input
* The app needs to be run on the 4" Retina iPhone for the UI to look right

Extra Credit
------------
* Backspace is implemented
* The whole expression is shown on the screen
* Disabling of buttons?

Sources Used for Reference
--------------------------
* developer.apple.com
* The occasional stack overflow about how to do something in Objective C that I know how to do in other languages
* Quite a few articles were used to figure out how to do a regex in Objective C
