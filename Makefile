name=ecx
pyw_folder=./pywrapper
pyw_ext_folder=./pywrapper/pyecx

.PHONY: fpm

fpm:
	fpm clean --all
	fpm build --profile=release

pywrapper: fpm
	rm -rf $(pyw_folder)/build
	rm -rf $(pyw_folder)/*.egg-info
	rm -rf $(pyw_ext_folder)/__pycache__
	rm -rf $(pyw_ext_folder)/*.h
	rm -rf $(pyw_ext_folder)/*.a
	rm -rf $(pyw_ext_folder)/*.so
	rm -rf $(pyw_ext_folder)/*.pyd
	rm -rf $(pyw_ext_folder)/*.dylib
	cp ./include/*h $(pyw_ext_folder)
	cp $(shell find ./build -type f -name "lib$(name)*.a") $(pyw_ext_folder)