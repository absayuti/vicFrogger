# VicFROGGER

A "Frogger" game clone written in *Commodore BASIC 2.0* for *Commodore VIC20* with 3KB memory expansion.

The program is divided into 2 files:

1. Loader (VICFROGGER) and definition of user-defined characters
2. Main program (VF2)

To run it in VICE, the files can be loaded from a .tap file (like a cassette) or from a .d64 file (like a disk).

**Tape loading**

1. Start VICE as VIC20 +3KB
2. Attach tape image *VicFrogger2026.tap*
3. Enter: *LOAD*
4. Select *Play* on *Tape*
5. When the program is loaded, enter: *RUN*

The program will run and load the next program (VF2) automatically.

**Disk loading**

Disk loading is similar a tape loading. The only difference is that the disk image *VicFrogger2026.d64* should be attached instead. Plus the loading command should be: LOAD "*",8.



