# logger
A personal keylogger. Tracks keys, commands, words, and screen (currently disabled). Writes to disk on interval specified in `Design.swift`. Python tool for creating composite image from screen captures in `python/*`.

## Setup

1. Build and run the Xcode project
2. Accept input privacy permission
3. Build and run again
4. Move resulting .app to Applications

## Usage

Runs as an agent app (invisible). On launch, will print top keys, commands, and words. Visible in `Console.app` by filtering for the `com.andrewfinke.logger` subsystem.

