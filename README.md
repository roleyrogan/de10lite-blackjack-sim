# 🃏 Blackjack Simulator (FPGA DE10-Lite)

[cite_start]An interactive, hardware-based **Blackjack Game Simulator** built using Verilog/SystemVerilog on the Intel **MAX 10 DE10-Lite FPGA board**[cite: 7]. [cite_start]This project combines combinational and sequential digital logic to recreate the classic casino card game, managing game states automatically and outputting results to the onboard peripherals[cite: 14, 15].

---

## 🎮 Features & Hardware Mapping

The game maps casino rules directly onto the physical components of the DE10-Lite board:

* [cite_start]**7-Segment Displays:** Shows the live card totals for both the Player (right side) and the Dealer (left side)[cite: 5, 12]. [cite_start]It also displays the final game result: **"W"** for a Win, **"L"** for a Loss, and **"T"** for a Tie[cite: 10].
* [cite_start]**Push Buttons (KEYs):** Used for game initialization and player actions (Hit, Stand, and Reset)[cite: 5, 11, 17].
* [cite_start]**LED Animations:** Built-in flashing visual alerts that react dynamically based on the round's outcome[cite: 5, 13].

---

## 🛠️ Digital Design Architecture

For those interested in the underlying digital logic circuits, this project bridges several core hardware concepts:

* [cite_start]**Combinational Logic:** Handles the arithmetic[cite: 14]. [cite_start]It continuously calculates player/dealer card totals using hardware adders, evaluates scores via comparators, and decodes binary data into readable text for the 7-segment displays[cite: 5, 14].
* [cite_start]**Sequential Logic (FSM):** Controls the step-by-step state transitions of the game (Initialization $\rightarrow$ Dealing $\rightarrow$ Player Turn $\rightarrow$ Automated Dealer Turn $\rightarrow$ Results)[cite: 15]. [cite_start]It uses a custom internal clock divider and delay counter to process timed actions[cite: 5].
* [cite_start]**Random Number Generation:** Simulates a random card draw yielding values from 1 to 10 whenever a player or dealer hits[cite: 5, 8].

---

## 🕹️ How to Play

1. [cite_start]**Initialize:** Press **KEY1** to start the game[cite: 17]. [cite_start]Wait a couple of seconds for the system to deal 2 initial cards to you and 1 visible card to the Dealer[cite: 5, 18].
2. [cite_start]**Player's Turn:** * Press **KEY1** to **Hit** (draws another card and updates your total)[cite: 19].
   * [cite_start]Press **KEY0** to **Stand** (locks your score and passes the turn to the dealer)[cite: 19].
   * [cite_start]*Note:* If your total goes over 21, you automatically "Bust", ending the game in an instant loss[cite: 5, 20].
3. [cite_start]**Dealer's Turn:** The AI Dealer takes over automatically, hitting at 1-second intervals until their total reaches **17 or higher**[cite: 5, 21]. [cite_start]If the dealer goes over 21, they bust and you win[cite: 5, 25].
4. [cite_start]**Reset:** Once the results phase concludes, press **KEY0** to clear the board, return totals to 0, and play again[cite: 5, 27].

### 🚨 LED Status Indicator Guide
* [cite_start]🏆 **Player Wins / Tie ("W"):** Even and odd numbered LEDs alternate flashing[cite: 5, 23, 26].
* [cite_start]❌ **Dealer Wins / Player Busts ("L"):** All onboard LEDs blink on and off repeatedly[cite: 5, 24, 26].
* [cite_start]⏳ **During Play:** LEDs maintain their current state until the game is reset[cite: 5].

---

## 📦 Project Directory Layout

```text
├── simulation/           # ModelSim simulation files and testbenches
├── src/                  # Hardware source code
│   └── BlackJackSim.v    # Main Verilog logic file
├── BlackJackSim.qpf      # Quartus Project File
├── BlackJackSim.qsf      # Quartus Settings (Pin assignments for DE10-Lite)
└── README.md             # Project documentation