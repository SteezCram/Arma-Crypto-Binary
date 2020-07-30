/*
	Name: fn_bitwiseXor.sqf
	Author: Steez
	Description: Bitwise XOR a binary representation
	
	Method: bitwiseOr
	Arguments:
		* `_x` - binary representation to use (i.e [1, 0, 0, ..., 1])
		* `_y` - binary representation to use (i.e [1, 0, 0, ..., 1])
		* `_bits` - int bits width, _x and _y need to have the same bits width !!!
	Return:
		* `array number` - bitwise XOR binary representation (i.e [1, 0, 0, ..., 1])
*/

params [["_x", [], [[]]], ["_y", [], [[]]], ["_bits", 0, [0]]];
// Set the bits width
if (_bits isEqualTo 0) then { _bits = 32 };

// Add all the missing bits to the _x array
reverse _x;
for "_i" from 0 to (_bits - count(_x) - 1) do {
	_x pushBack 0;
};
reverse _x;

// Add all the missing bits to the _y array
reverse _y;
for "_i" from 0 to (_bits - count(_y) - 1) do {
	_y pushBack 0;
};
reverse _y;


// Apply the operation
_result = [];
for "_i" from 0 to _bits -1 do {
	if ((_x # _i) != ((_y # _i))) then {
		_result pushBack 1;
	} else {
		_result pushBack 0;
	};
};

_result;