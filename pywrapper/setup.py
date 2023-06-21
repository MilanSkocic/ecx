import importlib
import pathlib
import platform
from setuptools import setup, find_packages, Extension

# Import only version.py file for extracting the version
spec = importlib.util.spec_from_file_location('version', './pyecx/version.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

libraries = None
library_dirs = None
runtime_library_dirs = None
extra_objects = None

if platform.system() == "Linux":
    libraries = ["ecx"]
    library_dirs = ["./pyecx"]
    runtime_library_dirs = ["$ORIGIN"]
if platform.system() == "Windows":
    extra_objects = ["./pyecx/libecx.dll.a"]
if platform.system() == "Darwin":
    libraries = ["ecx"]
    library_dirs = ["./pyecx"]
    runtime_library_dirs = ["@loader_path"]


if __name__ == "__main__":

    mod_ext = Extension(name="pyecx.eis",
                        sources=["./pyecx/ecx_eis.c"],
                        libraries=libraries,
                        library_dirs=library_dirs,
                        runtime_library_dirs=runtime_library_dirs,
                        extra_objects=extra_objects)

    setup(name=mod.__package_name__,
        version=mod.__version__,
        maintainer=mod.__maintainer__,
        maintainer_email=mod.__maintainer_email__,
        author=mod.__author__,
        author_email=mod.__author_email__,
        description=mod.__package_name__,
        long_description=pathlib.Path("README.rst").read_text(encoding="utf-8"),
        url='https://milanskocic.github.io/ecx/index.html',
        download_url='https://github.com/MilanSkocic/pyecx',
        packages=find_packages(),
        include_package_data=False,
        package_data={"pyecx": ["libecx.*"]},
        python_requires='>=3.8',
        install_requires=pathlib.Path("requirements.txt").read_text(encoding="utf-8").split('\n'),
        classifiers=["Development Status :: 5 - Production/Stable",
                    "Intended Audience :: Science/Research",
                    "License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
        ext_modules=[mod_ext]
        )


# pypi
# >>> python setup.py sdist bdist_wheel
# >>> python -m twine upload dist/*
# >>> python -m twine upload --repository testpypi dist/*