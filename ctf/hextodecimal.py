import sys

# Check if the correct number of command-line arguments is provided
if len(sys.argv) != 2:
    print("Usage: python3 script.py <hexadecimal_value>")
    sys.exit(1)

# Get the hexadecimal string from the command-line argument
hex_string = sys.argv[1]

try:
    # Convert hexadecimal to decimal
    decimal_value = int(hex_string, 16)

    # Print the decimal value
    print("Decimal:", decimal_value)
except ValueError:
    print("Invalid hexadecimal value provided.")
