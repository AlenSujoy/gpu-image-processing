all:
	nvcc src/image_blur.cu -o blur.exe

run:
	./blur.exe

clean:
	rm -f blur.exe
