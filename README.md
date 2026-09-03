# UART (Universal Asynchronous Receiver/Transmitter)

**Overview**

This project implements a UART (Universal Asynchronous Receiver/Transmitter) Transmitter and Receiver using Verilog/SystemVerilog.

The design supports four selectable baud rates:
- 9600 baud
- 19200 baud
- 38400 baud
- 115200 baud

The UART supports asynchronous serial communication using a frame consisting of an Idle state, Start bit, Data bits, Parity bit, and Stop bit.

The project demonstrates UART transmission and reception, baud-rate generation, parity generation/checking, serial-to-parallel conversion, and parallel-to-serial conversion.

**Features**
- UART Transmitter
- UART Receiver
- Four selectable baud rates:
9600
19200
38400
115200
- RTL implementation
- Simulation/testbench support
- UART Frame Format

The UART frame used in this design is:

       IDLE       START         DATA             PARITY      STOP
        1           0       D0 D1 D2 .... D7        P          1
        │           │       │ ──────────── │        │          │
        └───────────┴───────┴──────────────┴────────┴──────────┘


Each UART frame consists of:

Idle + Start Bit + 8 Data Bits + Parity Bit + Stop Bit


The UART line remains in the Idle HIGH state when no data is being transmitted.


Both the transmitter and receiver must use the same baud-rate configuration for reliable communication.

**Block Diagram**
<img width="457" height="427" alt="image" src="https://github.com/user-attachments/assets/8ee1c73d-313a-4ba2-9e4d-44e36818e14c" />


**UART Transmitter**

The UART transmitter converts parallel 8-bit data into a serial data stream.

Transmission Sequence

The transmitter follows these steps:

- Remains in the IDLE state.
- Waits for a transmission request.
- Loads the 8-bit parallel data.
- Generates the Start bit (0).
- Transmits the 8 data bits LSB first.
- Generates the Parity bit.
- Generates the Stop bit (1).
- Returns to the IDLE state.

Conceptually:

             ┌─────────┐
             │  IDLE   │
             └────┬────┘
                  │ TX Start
                  ▼
             ┌─────────┐
             │  START  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  DATA   │
             │  D0-D7  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │ PARITY  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  STOP   │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  IDLE   │
             └─────────┘

**UART Receiver**

The UART receiver converts the incoming serial data stream back into 8-bit parallel data.

Reception Sequence
- The receiver continuously monitors the RX line.
- The RX line is normally HIGH during IDLE.
- A transition from HIGH to LOW indicates a possible Start bit.
- The receiver samples the incoming data at the appropriate baud-rate timing.
- The 8 data bits are received LSB first.
- The receiver samples the Parity bit.
- The receiver checks the received parity.
- The Stop bit is checked.
- The received 8-bit data is presented at the output.
- The receiver returns to the IDLE state.

Conceptually:

             ┌─────────┐
             │  IDLE   │
             └────┬────┘
                  │ Start detected
                  ▼
             ┌─────────┐
             │  START  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  DATA   │
             │  D0-D7  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │ PARITY  │
             │  CHECK  │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  STOP   │
             └────┬────┘
                  ▼
             ┌─────────┐
             │  IDLE   │
             └─────────┘

**Parity**

The parity bit provides basic error detection during UART communication.

The transmitter calculates the parity from the 8-bit data and sends it after the data bits.

The receiver recalculates/checks the parity and compares it with the received parity bit.

If the parity does not match, a parity error can be generated.

<img width="380" height="188" alt="image" src="https://github.com/user-attachments/assets/3e52598d-8b08-4fd9-aff4-4acd7d7c0ca8" />



The exact parity type (even or odd) should match the RTL implementation. If this project uses even parity, the parity bit is selected so that the total number of 1s in the data + parity is even.

**Baud Rate Generator**

The baud-rate generator creates the timing required for UART transmission and reception.

For a system clock frequency of Fclk:

Baud Counter ≈ Fclk / Baud Rate


For example, with a 50 MHz system clock:

- Baud Rate	Approx. Clock Cycles/Bit
- 9600	                        5208
- 19200	                 2604
- 38400	                 1302
- 115200	                  434

The exact counter values depend on the system clock frequency and the baud-rate-generation architecture used in the design.


For an 8-bit data frame with one start bit, one parity bit, and one stop bit, the active frame contains 11 bits:

1 Start + 8 Data + 1 Parity + 1 Stop = 11 bits


The Idle state is the line state between frames and is normally HIGH.

<img width="228" height="377" alt="image" src="https://github.com/user-attachments/assets/811949f4-68e1-4b73-86d2-4bdd3c735855" />




**Verification Checks**
The testbench can verify:

Correct Idle state

Correct Start bit

Correct 8-bit data transmission

LSB-first transmission

Correct parity generation

Correct parity checking

Correct Stop bit

Correct baud-rate timing

Correct baud-rate selection

TX/RX data matching

Parity-error detection

Expected Result

**Applications**


UART communication is widely used in:

FPGA-to-PC communication

FPGA-to-microcontroller communication

Embedded systems

Debugging and serial monitoring

Sensor interfaces

Peripheral communication

Hardware testing and validation

**Future Improvements**

Possible improvements include:

Support for configurable data width

Configurable even/odd parity

Multiple stop-bit configurations

FIFO implementation

Framing-error detection

Overrun-error detection

Break detection

FPGA hardware testing

PC-based UART communication

Additional baud rates

**Conclusion**

This project implements a configurable UART Transmitter and Receiver supporting 9600, 19200, 38400, and 115200 baud rates.

The UART frame consists of an Idle state, Start bit, 8 Data bits, Parity bit, and Stop bit. The transmitter converts parallel data into a serial stream, while the receiver reconstructs the serial stream into parallel data and performs parity checking.

This project provides practical experience with RTL design, FSM-based control, baud-rate generation, serial communication, parity handling, timing, and functional verification.
