/*
	Name: fn_rightShift.sqf
	Author: Steez
	Description: Right shift a number
	
	Method: leftShift
	Arguments:
		* `_x` - int number
		* `_y` - int number
	Return:
		* `int` - right shifted number
*/

params [["_x", 0, [0]], ["_y", 0, [0]]];
floor((_x / (2 ^ _y)))