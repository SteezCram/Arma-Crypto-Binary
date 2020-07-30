/*
	Name: fn_leftShift.sqf
	Author: Steez
	Description: Left shift a number
	
	Method: leftShift
	Arguments:
		* `_x` - int number
		* `_y` - int number
	Return:
		* `int` - left shifted number
*/

params [["_x", 0, [0]], ["_y", 0, [0]]];
(_x * (2 ^ _y))