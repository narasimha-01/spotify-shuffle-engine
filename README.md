# 🎵 Spotify Shuffle Engine
### A Verilog-Based Hardware Shuffle Engine

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog%202001-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulation-Icarus%20Verilog-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Waveform-GTKWave-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Simulation%20Complete-success?style=for-the-badge" />
</p>

## 📌 Overview

What if we could recreate the logic behind Spotify's shuffle feature using digital hardware?

**Spotify Shuffle Engine** is a Verilog-based digital logic project that demonstrates how a hardware system can select songs using a Linear Feedback Shift Register (LFSR), track previously selected songs, and manage playlist rounds without repeating a song within the same round.

The project is implemented and simulated using free tools on a laptop, without requiring any physical FPGA hardware.

## 🎯 Project Objectives

- Design a 16-song shuffle engine.
- Generate pseudo-random values using a 5-bit LFSR.
- Track played songs using a 16-bit register.
- Prevent duplicate song selections within a round.
- Detect when all 16 songs have been played.
- Reset the played mask when a new round begins.
- Verify the design through simulation and waveform analysis.

## ⚙️ How It Works

The design uses three major concepts:

### 1. Linear Feedback Shift Register (LFSR)

A 5-bit LFSR generates a sequence of pseudo-random states using XOR feedback logic.

A non-zero initial seed is used to prevent the LFSR from getting stuck in the all-zero state.

### 2. Played Mask Register

A 16-bit register tracks which songs have already been selected.

Each bit represents one song:

- `0` – Song not played.
- `1` – Song already played.

### 3. Shuffle Controller

The controller checks the generated song index against the played mask.

- If the song is already played, it checks another LFSR state.
- If the song is not played, it selects that song.
- After all 16 songs are selected, the round completion signal is activated.
- The played mask is cleared for the next round.

## 🏗️ Architecture

```text
             NEXT BUTTON
                  |
                  v
          +---------------+
          | Shuffle       |
          | Controller    |
          +---------------+
                  |
          +-------+-------+
          |               |
          v               v
     +---------+    +-------------+
     |  LFSR   |    | Played Mask |
     | 5-bit   |    | 16-bit      |
     +---------+    +-------------+
          |               |
          +-------+-------+
                  |
                  v
          +---------------+
          | Song Selection|
          | Logic         |
          +---------------+
                  |
          +-------+--------+
          |                |
          v                v
     Current Song      Round Done
```

## 🔢 Design Specifications

| Parameter | Description |
|---|---|
| Playlist size | 16 songs |
| Song indices | 0–15 |
| Random generator | 5-bit LFSR |
| Tracking register | 16-bit Played Mask |
| HDL | Verilog-2001 |
| Clock | 10 ns period in testbench |
| Reset | Active-high |
| Input | `next_btn` |
| Outputs | `current_song`, `round_done`, `played_mask` |

## 🧰 Tools & Technologies

| Tool | Purpose |
|---|---|
| Icarus Verilog | Verilog compilation and simulation |
| GTKWave | Digital waveform visualization |
| MSYS2 UCRT64 | Development environment |
| Verilog-2001 | Hardware description language |

All tools used in this project are free.

## 📂 Project Structure

```text
spotify_shuffle/
│
├── spotify_shuffle.v
│   ├── lfsr5
│   ├── shuffle_controller
│   └── spotify_shuffle_top
│
├── tb_spotify_shuffle.v
│
├── shuffle.vcd
│
├── spotify_shuffle.gtkw
│
└── README.md
```

## 🚀 Run the Project

### Step 1: Clone the repository

```bash
git clone YOUR_REPOSITORY_URL
cd spotify_shuffle
```

### Step 2: Compile the Verilog files

```bash
iverilog -g2001 -Wall -o shuffle_sim spotify_shuffle.v tb_spotify_shuffle.v
```

### Step 3: Run the simulation

```bash
vvp shuffle_sim
```

### Step 4: Open the waveform

```bash
gtkwave shuffle.vcd spotify_shuffle.gtkw
```

## 📊 Simulation Results

The design was tested with 40 NEXT button presses.

| Test Parameter | Observed Result |
|---|---:|
| Total NEXT presses | 40 |
| Completed rounds | 2 |
| Songs in Round 1 | 16 |
| Songs in Round 2 | 16 |
| Songs in Round 3 | 8 |
| Round completion pulses | 2 |
| Final simulation time | 840 ns |

### Waveform Verification

The following signals were inspected in GTKWave:

- `clk`
- `rst`
- `next_btn`
- `current_song`
- `lfsr_state`
- `selected_index`
- `played_mask`
- `found`
- `new_round`
- `round_done`

The played mask reaches `FFFF` at the end of each completed round, and the round completion signal produces a pulse.

## ⚠️ Current Implementation Notes

- The project is currently simulation-only.
- It does not connect to Spotify APIs or play actual audio.
- The current LFSR-based implementation produces a deterministic sequence. The same sequence is observed in consecutive rounds.
- Improving round-to-round sequence variation and further hardware optimization are potential future improvements.

## 🔮 Future Improvements

- Improve shuffle variation between playlist rounds.
- Add a configurable playlist size.
- Implement a more advanced pseudo-random selection algorithm.
- Optimize the controller for FPGA implementation.
- Develop a real-time hardware demonstration using an FPGA board.

## 📚 Concepts Learned

- Linear Feedback Shift Registers (LFSR)
- XOR-based feedback logic
- Sequential and combinational logic
- Registers and bitmask operations
- State tracking
- Verilog module design
- Testbench development
- Simulation and waveform debugging

## 👨‍💻 Author

**Narasimha Lakkimsetty**

Final-Year B.Tech Electronics and Communication Engineering Student

Interested in VLSI Design, RTL Design, Digital Verification and Hardware Engineering.

---

<p align="center">
  <b>VERILOG IN REAL LIFE</b><br>
  Turning everyday technology into digital logic projects.
</p>
