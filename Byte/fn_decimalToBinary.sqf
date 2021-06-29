/*
	Name: fn_decimalToBinary.sqf
	Author: Steez
	Description: Convert a number into it's binary representation
	
	Method: decimalToBinary
	Arguments:
		* `_n` - int to convert
	Return:
		* `array number` - binary representation array of the number (i.e [1, 0, 0, ..., 1])
*/

params [["_n", 0, [0]]];

private _k = [];

// Get the binary value
while {_n > 0} do {
	_a = _n % 2;
	_k pushBack _a;
	_n = (_n - _a) / 2;
};

// Reverse the array
reverse _k;
_k;