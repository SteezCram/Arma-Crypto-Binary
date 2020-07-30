/*
	Name: fn_truncateBinary.sqf
	Author: Steez
	Description: Truncate a binary representation with a specific bits width
	
	Method: truncateBinary
	Arguments:
		* `_b` - binary representation to convert (i.e [1, 0, 0, ..., 1])
	Return:
		* `array number` - the binary representation truncate
*/

params [["_b", [], [[]]]];

_returnB = +_b;

// Truncate the array
for "_i" from 0 to count(_b) - 1 do {
	if ((_b # _i) isEqualTo 0) then {
		_returnB deleteAt 0;
	};
	if ((_b # _i) isEqualTo 1) exitWith {};
};

_returnB;