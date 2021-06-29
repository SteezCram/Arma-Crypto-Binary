/*
	Name: fn_byteToCodePoint.sqf
	Author: Steez
	Description: Transform a byte or byte array to code point.
	
	Method: arcfour
	Arguments:
		* `_byteOrBytes` - byte or byte array sequence to convert
	Return:
		* `number` - unicode code point
*/

//params [["_byteOrBytes", [], [0, []]]];
params ["_byteOrBytes"];


// Function helper
private _decimalToBinary = {
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
};
private _binaryToDecimal = {
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
};
private _truncateBinary = {
	params [["_b", [], [[]]]];

	private _returnB = +_b;

	// Truncate the array
	for "_i" from 0 to count(_b) - 1 do {
		if ((_b # _i) isEqualTo 0) then {
			_returnB deleteAt 0;
		};
		if ((_b # _i) isEqualTo 1) exitWith {};
	};

	_returnB;
};

// Bitwise functions
private _bitwiseAnd = {
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
	private _result = [];
	for "_i" from 0 to _bits -1 do {
		if (((_x # _i) isEqualTo 1) && ((_y # _i) isEqualTo 1)) then {
			_result pushBack 1;
		} else {
			_result pushBack 0;
		};
	};

	_result;
};
private _bitwiseOr = {
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
	private _result = [];
	for "_i" from 0 to _bits -1 do {
		if (((_x # _i) isEqualTo 1) || ((_y # _i) isEqualTo 1)) then {
			_result pushBack 1;
		} else {
			_result pushBack 0;
		};
	};

	_result;
};

// Shifting functions
private _leftShift = {
	params [["_x", 0, [0]], ["_y", 0, [0]]];
	(_x * (2 ^ _y))
};
private _rightShift = {
	params [["_x", 0, [0]], ["_y", 0, [0]]];
	floor((_x / (2 ^ _y)))
};


// Main logic
private _return = [];

if (typeName _byteOrBytes isEqualTo "ARRAY") then {

	switch (count(_byteOrBytes)) do 
	{
		case 2: {
			private _firstByteBin = (_byteOrBytes # 0) call _decimalToBinary;
			private _secondByteBin = (_byteOrBytes # 1) call _decimalToBinary;

			_firstByteBin = [_firstByteBin, 0x1f call _decimalToBinary] call _bitwiseAnd;
			_secondByteBin = [_secondByteBin, 0x3f call _decimalToBinary] call _bitwiseAnd;
			private _firstByteNumber = [[[_firstByteBin] call _truncateBinary] call _binaryToDecimal, 6] call _leftShift;
			private _secondByteNumber = [[[_secondByteBin] call _truncateBinary] call _binaryToDecimal, 0] call _leftShift;

			_firstByteBin = _firstByteNumber call _decimalToBinary;
			_secondByteBin = _secondByteNumber call _decimalToBinary;

			private _returnBin = [_firstByteBin, _secondByteBin] call _bitwiseOr;
			_return = [[_returnBin] call _truncateBinary] call _binaryToDecimal;
			// ( m & 0x1f ) << 6 | ( n & 0x3f ) << 0
		};
		default {
			throw "insupported character";
		};
	}
}
else 
{
	private _byteBin = _byteOrBytes call _decimalToBinary;
	_byteBin = [_byteBin, 0x7f call _decimalToBinary] call _bitwiseAnd;

	private _byteNumber = [[_byteBin] call _truncateBinary] call _binaryToDecimal;

	_return = [_byteNumber, 0] call _leftShift;
	// ( m & 0x7f ) << 0
};


_return;
