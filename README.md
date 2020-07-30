# Arma Crypto-Binary

Arma Crypto-Binary is repostory to interact with binary data in Arma 3.
This repository contains several methods to transform a number to it's binary representation. Each binary representation is an array of string, because it's easier to apply the bitwise operation on them.


## Binary Data

#### Number => Binary / Binary => Number
You have several methods to deal with binary number. 
The representation of the number in binary is like this:
`8 => [1, 0, 0, 0]`

You have a method to convert it back, and another to truncate it, if the binary representation is on a specific bits width (that is the case when you do a bitwise operation).

### Byte from string
You can now extract all the byte from a string. The method need the Unicode code point of the character. The current implementation is limited to a codepoint of 2048.

You can find the code point by using this method: [toArray](https://community.bistudio.com/wiki/toArray)
### Bitwise / Shifting operation
Arma 3 doesn't support byte type, so it doesn't have any bitwise / shifting operation. So I recreate them.

Bitwise operation:
- bitwise AND
- bitwise OR
- bitwise XOR

Shifting operation:
- Left shift
- Right shift

The shifting operation is on a number, the bitwise operation are on a binary array number. For all the bitwise you can set the width of the number. Don't forget that this method need to have all the number in the same width to operate.

## Encryption
### Arcfour:
This repository contains a valid implementation of [Arcfour (or RC4)](https://en.wikipedia.org/wiki/RC4). You can crypt and decrypt with this method.
To decrypt data you need to pass the encrypted data to the method, it will convert it back.

This encryption method is considered like unsecure, but it's a good example to test the performance of encryption in Arma 3. Also it can be a sufficient protection for all the people who don't know that.
