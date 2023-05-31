pyecx_dir=./pyecx
header_dir=../include
fpm_build_dir=../build

all: sdist bdist_wheel

build: clean
	cp $(header_dir)/*h $(pyecx_dir)/
	cp $(shell find $(fpm_build_dir) -type f -name "lib$(name)*.a") $(pyecx_dir)/
	$(PY) setup.py build_ext --inplace
	rm -rf $(pyecx_dir)/*.h
	rm -rf $(pyecx_dir)/*.a
	
	
sdist: build
	$(PY) setup.py sdist

bdist_wheel: build
	$(PY) setup.py bdist_wheel

clean:
	rm -rf ./build
	rm -rf ./*.egg-info
	rm -rf $(pyecx_dir)/__pycache__
	rm -rf $(pyecx_dir)/*.h
	rm -rf $(pyecx_dir)/*.a
	rm -rf $(pyecx_dir)/*.so
	rm -rf $(pyecx_dir)/*.pyd
	rm -rf $(pyecx_dir)/*.dylib