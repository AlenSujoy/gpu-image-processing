# CUDA GPU Image Processing Project

## Description
This project demonstrates GPU-based image processing using CUDA. A blur filter is applied using parallel threads on the GPU.

## How It Works
- Each CUDA thread processes one pixel
- A 3x3 blur kernel is applied
- GPU parallelism speeds up computation

## How to Run
make
./blur.exe


## Output
- output/output.txt (execution log)

## GPU Usage
Thousands of CUDA threads run in parallel to process image data efficiently.
