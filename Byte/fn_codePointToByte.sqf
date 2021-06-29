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

if (_codePoint < 0x80) then {
	_return = _codePoint;
};
if (_codePoint >= 0x80 && _codePoint < 0x800) then 
{
	private _bin0xC0 = 0xC0 call _decimalToBinary;
	private _binCodePoint = call _decimalToBinary;
	private _bin0x80 = 0x80 call _decimalToBinary;
	private _bin0x3F = 0x3F call _decimalToBinary;

	private _codePointShift = [_codePoint, 6] call _rightShift;
	private _codePointBitwiseAnd = [_binCodePoint, _bin0x3F] call _bitwiseAnd;
	private _firstByteBin = [_bin0xC0, [_codePointShift] call _decimalToBinary] call _bitwiseOr;
	private _secondByteBin = [_bin0x80, [_bin0x3F, _codePointBitwiseAnd] call _bitwiseAnd] call _bitwiseOr;

	private _firstByteNumber = [[_firstByteBin] call _truncateBinary] call _binaryToDecimal;
	private _secondByteNumber = [[_secondByteBin] call _truncateBinary] call _binaryToDecimal;

	_return = [_firstByteNumber, _secondByteNumber];
};
/*if (_codePoint >= 0x800 && _codePoint < 0x10000) then {
	_return = [(0xE0 | (_codePoint >> 12)), (0x80 | (_codePoint >> 6 & 0x3F)), (0x80 | (_codePoint & 0x3F))];
};
if (_codePoint >= 0x10000 && _codePoint < 0x110000) then {
	_return = [(0xF0 | (_codePoint >> 12)), (0x80 | (_codePoint >> 12 & 0x3F)), (0x80 | (_codePoint >> 6 & 0x3F)), (0x80 | (_codePoint & 0x3F))];
};*/

_return;