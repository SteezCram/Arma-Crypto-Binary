/*
	Name: fn_binaryToDecimal.sqf
	Author: Steez
	Description: Convert a binary representation to it's decimal representation
	
	Method: binaryToDecimal
	Arguments:
		* `_b` - binary representation to convert (i.e [1, 0, 0, ..., 1])
	Return:
		* `int` - the decimal representation of the binary representation
*/

params [["_b", [], [[]]]];

reverse _b;
private _d = 0;
private _p = 0;

// Compute the decimal number
{
	if (_x isEqualTo 1) then {
		_d = _d + 2 ^ _p;
	};
	_p = _p + 1;
} foreach _b;

_d;