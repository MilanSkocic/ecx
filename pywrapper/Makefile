pyecx_dir=./pyecx
header_dir=../include
fpm_build_dir=../build

.PHONY: prepare cleanup

prepare:
	rm -rf ./build
	rm -rf ./*.egg-info
	rm -rf $(pyecx_dir)/__pycache__
	rm -rf $(pyecx_dir)/*.a
	rm -rf $(pyecx_dir)/*.so
	rm -rf $(pyecx_dir)/*.pyd
	rm -rf $(pyecx_dir)/*.dylib
	cp $(shell find $(fpm_build_dir) -type f -name "lib$(name)*.a") $(pyecx_dir)/

cleanup:
	rm -rf ./build
	rm -rf ./*.egg-info
	rm -rf $(pyecx_dir)/__pycache__
	rm -rf $(pyecx_dir)/*.a