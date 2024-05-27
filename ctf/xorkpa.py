import sys

def hex_to_bytes(hex_string):
    # Convert a string of hex digits to a bytes object
    hex_string = hex_string.replace(" ", "").replace("\n", "")
    return bytes.fromhex(hex_string)

def simple_xor_bytes(data, key):
    # XOR two bytes objects of the same length without repeating the key
    return bytes(a ^ b for a, b in zip(data, key))

def xor_bytes_with_repeating_key(data, key):
    # Repeat the key to match the length of the data
    repeated_key = (key * (len(data) // len(key) + 1))[:len(data)]
    return bytes(a ^ b for a, b in zip(data, repeated_key))

def main(input_file, output_file):
    # Hex strings to be converted to byte objects
    # hex1 is known plaintext first 32 bytes "-----BEGIN OPENSSH PRIVATE KEY--"
    # hex 2 is first 32 bytes of the xored data
    hex1 = "2d 2d 2d 2d 2d 42 45 47 49 4e 20 4f 50 45 4e 53 53 48 20 50 52 49 56 41 54 45 20 4b 45 59 2d 2d" 
    hex2 = "af ef 7e 7d a6 97 09 00 ee ab 4d a3 88 33 fb 85 f7 6f e6 15 5b 42 24 a0 ed 34 13 69 bb b8 74 74"

    # Convert hex strings to bytes
    bytes1 = hex_to_bytes(hex1)
    bytes2 = hex_to_bytes(hex2)

    # XOR the byte arrays to get the XOR key without repeating the key
    xor_key = simple_xor_bytes(bytes1, bytes2)

    # Read the encrypted file as bytes
    with open(input_file, 'rb') as f:
        encrypted_data = f.read()

    # Decrypt the data using the XOR key with repeating logic
    decrypted_data = xor_bytes_with_repeating_key(encrypted_data, xor_key)

    # Try to decode the decrypted bytes to a string using UTF-8 encoding
    try:
        readable_data = decrypted_data.decode('utf-8')
        # Write the decoded string to the output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(readable_data)
    except UnicodeDecodeError:
        # If decoding fails, write the raw bytes to the output file
        with open(output_file, 'wb') as f:
            f.write(decrypted_data)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input file> <output file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    main(input_file, output_file)
