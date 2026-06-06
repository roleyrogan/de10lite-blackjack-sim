# 🃏 Blackjack Simulator (FPGA DE10-Lite)

An interactive, hardware-based **Blackjack Game Simulator** built using Verilog/SystemVerilog on the Intel **MAX 10 DE10-Lite FPGA board**. This project combines combinational and sequential digital logic to recreate the classic casino card game, managing game states automatically and outputting results to the onboard peripherals.

---

## 🎮 Features & Hardware Mapping

The game maps casino rules directly onto the physical components of the DE10-Lite board:

* **7-Segment Displays:** Shows the live card totals for both the Player (right side) and the Dealer (left side). It also displays the final game result: **"W"** for a Win, **"L"** for a Loss, and **"T"** for a Tie.
* **Push Buttons (KEYs):** Used for game initialization and player actions (Hit, Stand, and Reset).
* **LED Animations:** Built-in flashing visual alerts that react dynamically based on the round's outcome.

---

## 🛠️ Digital Design Architecture

For those interested in the underlying digital logic circuits, this project bridges several core hardware concepts:

* **Combinational Logic:** Handles the arithmetic. It continuously calculates player/dealer card totals using hardware adders, evaluates scores via comparators, and decodes binary data into readable text for the 7-segment displays.
* **Sequential Logic (FSM):** Controls the step-by-step state transitions of the game (Initialization $\rightarrow$ Dealing $\rightarrow$ Player Turn $\rightarrow$ Automated Dealer Turn $\rightarrow$ Results). It uses a custom internal clock divider and delay counter to process timed actions.
* **Random Number Generation:** Simulates a random card draw yielding values from 1 to 10 whenever a player or dealer hits.

---

## 🕹️ How to Play

1. **Initialize:** Press **KEY1** to start the game. Wait a couple of seconds for the system to deal 2 initial cards to you and 1 visible card to the Dealer.
2. **Player's Turn:** * Press **KEY1** to **Hit** (draws another card and updates your total).
   * Press **KEY0** to **Stand** (locks your score and passes the turn to the dealer).
   * *Note:* If your total goes over 21, you automatically "Bust", ending the game in an instant loss.
3. **Dealer's Turn:** The AI Dealer takes over automatically, hitting at 1-second intervals until their total reaches **17 or higher**. If the dealer goes over 21, they bust and you win.
4. **Reset:** Once the results phase concludes, press **KEY0** to clear the board, return totals to 0, and play again.

### 🚨 LED Status Indicator Guide
* 🏆 **Player Wins / Tie ("W"):** Even and odd numbered LEDs alternate flashing.
* ❌ **Dealer Wins / Player Busts ("L"):** All onboard LEDs blink on and off repeatedly.
* ⏳ **During Play:** LEDs maintain their current state until the game is reset.

---

## 📦 Project Directory Layout

```text
├── simulation/           # ModelSim simulation files and testbenches
├── src/                  # Hardware source code
│   └── BlackJackSim.v    # Main Verilog logic file
├── BlackJackSim.qpf      # Quartus Project File
├── BlackJackSim.qsf      # Quartus Settings (Pin assignments for DE10-Lite)
└── README.md             # Project documentation