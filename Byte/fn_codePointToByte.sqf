/*
	Name: fn_codePointToByte.sqf
	Author: Steez
	Description: Unicode code point converter to byte
				 This file is ready to use with no external dependency
	
	Method: codePointToByte
	Arguments:
		* `_codePoint` - int code point to convert
	Return:
		* `byte or byte array` - converted byte or byte array (depend of the code point)
*/

params [["_codePoint", 0, [0]]];

// Error handle
if (_codePoint isEqualTo 0) exitWith {};


// Function helper
_decimalToBinary = {
	params [["_n", 0, [0]]];
	_k = [];

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
_binaryToDecimal = {
	params [["_b", [], [[]]]];
	reverse _b;
	_d = 0;
	_p = 0;

	// Compute the decimal number
	{
		if (_x isEqualTo 1) then {
			_d = _d + 2 ^ _p;
		};
		_p = _p + 1;
	} foreach _b;

	_d;
};
_truncateBinary = {
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
};

// Bitwise functions
_bitwiseAnd = {
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
		if (((_x # _i) isEqualTo 1) && ((_y # _i) isEqualTo 1)) then {
			_result pushBack 1;
		} else {
			_result pushBack 0;
		};
	};

	_result;
};
_bitwiseOr = {
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
		if (((_x # _i) isEqualTo 1) || ((_y # _i) isEqualTo 1)) then {
			_result pushBack 1;
		} else {
			_result pushBack 0;
		};
	};

	_result;
};

// Shifting functions
_leftShift = {
	params [["_x", 0, [0]], ["_y", 0, [0]]];
	(_x * (2 ^ _y))
};
_rightShift = {
	params [["_x", 0, [0]], ["_y", 0, [0]]];
	floor((_x / (2 ^ _y)))
};


// Main logic
_return = [];

if (_codePoint < 0x80) then {
	_return = _codePoint;
};
if (_codePoint >= 0x80 && _codePoint < 0x800) then 
{
	_bin0xC0 = 0xC0 call _decimalToBinary;
	_binCodePoint = call _decimalToBinary;
	_bin0x80 = 0x80 call _decimalToBinary;
	_bin0x3F = 0x3F call _decimalToBinary;

	_codePointShift = [_codePoint, 6] call _rightShift;
	_codePointBitwiseAnd = [_binCodePoint, _bin0x3F] call _bitwiseAnd;
	_firstByteBin = [_bin0xC0, [_codePointShift] call _decimalToBinary] call _bitwiseOr;
	_secondByteBin = [_bin0x80, [_bin0x3F, _codePointBitwiseAnd] call _bitwiseAnd] call _bitwiseOr;

	_firstByteNumber = [[_firstByteBin] call _truncateBinary] call _binaryToDecimal;
	_secondByteNumber = [[_secondByteBin] call _truncateBinary] call _binaryToDecimal;

	_return = [_firstByteNumber, _secondByteNumber];
};
/*if (_codePoint >= 0x800 && _codePoint < 0x10000) then {
	_return = [(0xE0 | (_codePoint >> 12)), (0x80 | (_codePoint >> 6 & 0x3F)), (0x80 | (_codePoint & 0x3F))];
};
if (_codePoint >= 0x10000 && _codePoint < 0x110000) then {
	_return = [(0xF0 | (_codePoint >> 12)), (0x80 | (_codePoint >> 12 & 0x3F)), (0x80 | (_codePoint >> 6 & 0x3F)), (0x80 | (_codePoint & 0x3F))];
};*/

_return;