# UART Bit Stream Structure

## Start Bit:
- The UART transmission always begins with a start bit, which is a **logic low (0)** signal.
- This indicates to the receiver that a new data frame is about to be transmitted.

## Data Bits:
- After the start bit, the actual data bits are transmitted.
- The number of data bits is typically **8 bits**.
- The data bits are sent starting from the **least significant bit (LSB)**.
- This data represents the byte being communicated, and both the sender and receiver must agree on the number of bits being transmitted.

## Parity Bit:
- The parity bit is a feature used for **error detection**.
- It checks if the number of 1’s in the transmitted data bits is even or odd.

  **If parity is enabled:**
  - **Even parity**: The parity bit is set to 1 if the number of 1’s in the data is odd, making the total count even.
  - **Odd parity**: The parity bit is set to 1 if the number of 1’s in the data is even, making the total count odd.

## Stop Bit(s):
- The transmission ends with one or more stop bits, which are always **logic high (1)**.
- Stop bits provide a buffer between the end of one data frame and the start of the next.
- They ensure the receiver has enough time to process the data before another transmission begins.

## Idle Line:
- After the stop bit(s) are sent, the UART line returns to an **idle state**, which is a **logic high (1)**.
- The line remains idle until the next transmission begins with a new start bit.
- The idle state allows the system to differentiate between periods of activity and inactivity on the communication line.
