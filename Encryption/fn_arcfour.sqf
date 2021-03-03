/*
	Name: fn_arcfour.sqf
	Author: Steez
	Description: Valid implementation of Arcfour algorithm,
				 This file is ready to use with no external dependency
	
	Method: arcfour
	Arguments:
		* `_key` - string key to use, must have a length inferior or equal at 256
		* `_textOrBytes` - string text to encrypt / decrypt or byte array to encrypt / decrypt
		* `_isByte` - true if _textOrBytes is a byte array, else false
	Return:
		* `byte array` - encrypted byte array from _textOrBytes
*/

params [
	"_key",
	"_textOrBytes",
	["_isByte", false, [false]]
];

// Error handle
if (_key isEqualTo "") exitWith {};
if (_textOrBytes isEqualTo "" && !_isByte) exitWith {};
if (_textOrBytes isEqualTo [] && _isByte) exitWith {};

// Helper functions
_codePointToByte = {
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
};
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
_bitwiseXor = {
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
};


// Initialize variable
_keyCodePoints = toArray _key;
_keyBytes = [];
_textBytes = [];
_cipherList = [];

// Get the bytes for the key and the text
{ _keyBytes pushBack (_x call _codePointToByte); } forEach _keyCodePoints;
if (_isByte) then {
	_textBytes = _textOrBytes;
}
else {
	_textCodePoints = toArray _textOrBytes;
	{ _textBytes pushBack (_x call _codePointToByte); } forEach _textCodePoints;
};

_keyLen = count _keyBytes;
_textLen = count _textBytes;


// Create the state
_state = [];
for "_i" from 0 to 255 do {
	_state pushBack _i;
};

// Compute the state
_j = 0;
for "_i" from 0 to 255 do {
	_j = (_j + (_state # _i) + ((_keyBytes # (_i % _keyLen)))) mod 256;
	_t = (_state # _i);
	_state set [_i, (_state # _j)];
	_state set [_j, _t];
};


_i = 0;
_j = 0;
_transformByte = {
	params ["_byte", "_state"];

	// Compute the new byte
	_i = (_i + 1) mod 256;
	_j = (_j + (_state # _i)) mod 256;
	_t = (_state # _i);
	_state set [_i, (_state # _j)];
	_state set [_j, _t];

	// Get the final number
	_k = _state # (((_state # _i) + (_state # _j)) mod 256);
	// Convert the _k to binary and the number from the text bytes
	_kBin = _k call _decimalToBinary;
	_numberToAddBin = (_byte) call _decimalToBinary;

	// Get the new byte to add
	_numberToAddBitwiseXorBin = [[_kBin, _numberToAddBin, 8] call _bitwiseXor] call _truncateBinary;
	_return = [_numberToAddBitwiseXorBin] call _binaryToDecimal;

	_return;
};

for "_z" from 0 to _textLen -1 do {
	if (typeName (_textBytes # _z) isEqualTo "ARRAY") then { 
		_bytesToAdd = [];
		{ _bytesToAdd pushBack ([_x, _state] call _transformByte); } forEach (_textBytes # _z);

		_cipherList pushBack _bytesToAdd;
	}
	else {
		_cipherList pushBack ([(_textBytes # _z), _state] call _transformByte);
	};
};

_cipherList;
