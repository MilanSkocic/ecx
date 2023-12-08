import importlib
import pathlib
import platform
from setuptools import setup, find_packages, Extension

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

    mod_eis = Extension(name="pyecx.eis",
                        sources=["./pyecx/py_eis.c", "./pyecx/py_common.c"],
                        libraries=libraries,
                        library_dirs=library_dirs,
                        runtime_library_dirs=runtime_library_dirs,
                        extra_objects=extra_objects)
    mod_core = Extension(name="pyecx.core",
                         sources=["./pyecx/py_core.c", "./pyecx/py_common.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)

    setup(ext_modules=[mod_core, mod_eis])

