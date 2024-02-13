r"""setup"""
import platform
from setuptools import setup, Extension

libraries = None
library_dirs = None
runtime_library_dirs = None
extra_objects = None

if platform.system() == "Linux":
    libraries = ["ecx"]
    library_dirs = ["./src/pyecx"]
    runtime_library_dirs = ["$ORIGIN"]
if platform.system() == "Windows":
    extra_objects = ["./src/pyecx/libecx.dll.a"]
if platform.system() == "Darwin":
    libraries = ["ecx"]
    library_dirs = ["./src/pyecx"]
    runtime_library_dirs = ["@loader_path"]


if __name__ == "__main__":
    
    mod_version = Extension(name="pyecx.version",
                         sources=["./src/pyecx/cpy_version.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_eis = Extension(name="pyecx.eis",
                        sources=["./src/pyecx/cpy_eis.c", "./src/pyecx/cpy_common.c"],
                        libraries=libraries,
                        library_dirs=library_dirs,
                        runtime_library_dirs=runtime_library_dirs,
                        extra_objects=extra_objects)
    mod_core = Extension(name="pyecx.core",
                         sources=["./src/pyecx/cpy_core.c", "./src/pyecx/cpy_common.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)

    setup(ext_modules=[mod_version, mod_core, mod_eis])

