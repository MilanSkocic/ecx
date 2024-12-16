ifeq ($(FPM_PLATFORM), windows)
	PY=py -
endif
ifeq ($(FPM_PLATFORM), linux)
	PY=python
	AW=auditwheel repair --plat manylinux_2_31_x86_64 ./dist/*.whl
endif
ifeq ($(FPM_PLATFORM), darwin)
	PY=python
endif

SETUP=setup.py pyproject.toml

all: python3.8 python3.9 python3.10 python3.11 python3.12

python3.12: $(SETUP)
	@echo "########### PYTHON 3.12 ##########"
	$(PY)3.12 setup.py build_ext --inplace
	$(PY)3.12 -m build --no-isolation --sdist
	$(PY)3.12 -m build --no-isolation --wheel
	$(PY)3.12 -m unittest -v
	$(AW)
	@echo "#################################"

python3.11: $(SETUP)
	@echo "########### PYTHON 3.11 ##########"
	$(PY)3.11 setup.py build_ext --inplace
	$(PY)3.11 -m build --no-isolation --wheel
	$(PY)3.11 -m unittest -v
	@echo "#################################"

python3.10: $(SETUP)
	@echo "########### PYTHON 3.10 ##########"
	$(PY)3.10 setup.py build_ext --inplace
	$(PY)3.10 -m build --no-isolation --wheel
	$(PY)3.10 -m unittest -v
	@echo "#################################"

python3.9: $(SETUP)
	@echo "########### PYTHON 3.9 ##########"
	$(PY)3.9 setup.py build_ext --inplace
	$(PY)3.9 -m build --no-isolation --wheel
	$(PY)3.9 -m unittest -v
	@echo "#################################"

python3.8: $(SETUP)
	@echo "########### PYTHON 3.8 ##########"
	$(PY)3.8 setup.py build_ext --inplace
	$(PY)3.8 -m build --no-isolation --wheel
	$(PY)3.8 -m unittest -v
	@echo "#################################"

clean: 
	rm -rf build 
	rm -rf dist 
	rm -rf *.egg-info 
	rm -rf __pycache__ 
	rm -rf wheelhouse 
	rm -rf $(FPM_PY_SRC)/__pycache__
	rm -f $(FPM_PY_SRC)/$(FPM_NAME)*.h 
	rm -f $(FPM_PY_SRC)/*.a 
	rm -f $(FPM_PY_SRC)/*.so 
	rm -f $(FPM_PY_SRC)/*.dylib 
	rm -f $(FPM_PY_SRC)/*.dll 
	rm -f $(FPM_PY_SRC)/*.dll.a 
	rm -f $(FPM_PY_SRC)/*.pyd
	rm -rf $(FPM_PY_SRC)/bin
	rm -rf $(FPM_PY_SRC)/include
	rm -rf $(FPM_PY_SRC)/lib
