# Camera Input Design

**Date:** 2026-02-19
**Feature:** Real-time camera input converted to dot matrix display

## Goal

Feed live webcam frames into the existing `DotMatrix` class as grayscale brightness values, rendered in real-time using the matrix's configured dot color.

## Approach

Use Processing's `Video` library (`Capture` class). Resize each camera frame to match the matrix dimensions using built-in bilinear interpolation (`PImage.resize()`), then convert each pixel to a grayscale luma value (0–255) and load it into the matrix via `loadData()`.

## Data Flow

```
Webcam → Capture.read() → cam.resize(columns, rows) → cam.loadPixels()
  → luma = 0.299R + 0.587G + 0.114B → dot_data[i][j] → matrix.loadData() → matrix.draw()
```

## Changes Required

### `dot_matrix.pde` (main sketch)
- Add `import processing.video.*;`
- Declare `Capture cam` global
- In `setup()`: initialize `cam` with default device, call `cam.start()`
- In `draw()`: replace random-fill loop with camera frame read → resize → grayscale conversion

### `DotMatrix.pde`
- No changes. Existing `loadData(int[][])` and `draw()` APIs are sufficient.

## Constraints

- Requires the Processing Video library to be installed
- Camera resolution is arbitrary; resize step normalizes it to matrix dimensions
- Grayscale formula: ITU-R BT.601 luma — `0.299R + 0.587G + 0.114B`
