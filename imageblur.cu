#include <stdio.h>
#include <cuda_runtime.h>

#define WIDTH 256
#define HEIGHT 256

__global__ void blurKernel(unsigned char* input, unsigned char* output) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= WIDTH || y >= HEIGHT) return;

    int idx = y * WIDTH + x;

    int sum = 0;
    int count = 0;

    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            int nx = x + dx;
            int ny = y + dy;

            if (nx >= 0 && nx < WIDTH && ny >= 0 && ny < HEIGHT) {
                sum += input[ny * WIDTH + nx];
                count++;
            }
        }
    }

    output[idx] = sum / count;
}

int main() {
    FILE* f = fopen("output/output.txt", "w");

    int size = WIDTH * HEIGHT * sizeof(unsigned char);

    unsigned char *h_input, *h_output;
    h_input = (unsigned char*)malloc(size);
    h_output = (unsigned char*)malloc(size);

    for (int i = 0; i < WIDTH * HEIGHT; i++) {
        h_input[i] = rand() % 256;
    }

    unsigned char *d_input, *d_output;
    cudaMalloc(&d_input, size);
    cudaMalloc(&d_output, size);

    cudaMemcpy(d_input, h_input, size, cudaMemcpyHostToDevice);

    dim3 threads(16,16);
    dim3 blocks(WIDTH/16, HEIGHT/16);

    blurKernel<<<blocks, threads>>>(d_input, d_output);

    cudaMemcpy(h_output, d_output, size, cudaMemcpyDeviceToHost);

    printf("GPU blur completed successfully.\n");
    fprintf(f, "GPU blur completed successfully.\n");

    fclose(f);

    cudaFree(d_input);
    cudaFree(d_output);
    free(h_input);
    free(h_output);

    return 0;
}
