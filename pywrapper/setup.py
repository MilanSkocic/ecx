import os
import configparser
import importlib
import pathlib
import platform
from setuptools import setup, find_packages, Extension

# Import only version.py file for extracting the version
spec = importlib.util.spec_from_file_location('version', './pyecx/version.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

def get_custom_cfg(fpath):
    cfg = configparser.RawConfigParser()
    if fpath.exists():
        print(f"{fpath.name} was found.")
        cfg.read(fpath)
    else:
        print(f"{fpath.name} was not found.")

    return cfg

def set_extensions():
    if platform.system() == "Windows":
        prefix = ""
        ext_shared = ".dll"
        ext_static = ".lib"
    elif platform.system() == "Darwin":
        prefix = "lib"
        ext_shared = ".dylib"
        ext_static = ".a"
    else:
        prefix = "lib"
        ext_shared = ".so"
        ext_static = ".a"
    return prefix, ext_shared, ext_static

def get_default_dirs(dir_name):
    dirs = []
    for root in all_roots:
        dirs.append(root + f"/{dir_name}")
    
    return ",".join(dirs)

def search_headers(include_dirs, libraries):
    found = 0
    for library in libraries:
        print(f"Looking for {library}.h...")
        for dir_ in include_dirs:
            fdir = pathlib.Path(dir_)
            if fdir.exists():
                fpath = fdir / f"{library}.h"
                print(f"\t{fpath}...{fpath.exists()}")
                if fpath.exists():
                    found += 1

    return found
                
def search_libraries(lib_dirs, libraries, static=False):
    found = 0
    prefix, ext_shared, ext_static = set_extensions()
    if static:
        ext = ext_static
    else:
        ext = ext_shared
    for library in libraries:
        print(f"Looking for {library}{ext}...")
        for dir_ in lib_dirs:
            fdir = pathlib.Path(dir_)
            if fdir.exists():
                fpath = fdir / (prefix+f"{library}"+ext)
                print(f"\t{fpath}...{fpath.exists()}")
                if fpath.exists():
                    found += 1

    return found

# default roots for library dirs
unix_roots = ["/usr", "/usr/local"]
win_roots = ["C:/Program Files/ecx"]
user_roots = [os.path.expanduser("~")+"/ecx", os.path.expanduser("~")+"/.local"]
all_roots = unix_roots + win_roots + user_roots

default_include_dirs = get_default_dirs("include")
default_lib_dirs = get_default_dirs("lib")


# Set dirs for codata library
cfg_dict = {"ecx": {"libraries": "ecx",
                       "include_dirs": default_include_dirs,
                       "library_dirs": default_lib_dirs}}

cfg = configparser.RawConfigParser()
cfg.read_dict(cfg_dict)
cfg_user = get_custom_cfg(pathlib.Path("site.cfg"))
cfg_package = get_custom_cfg(pathlib.Path(os.path.expanduser("~")) / "pyecx-site.cfg")
cfg.update(cfg_user)
cfg.update(cfg_package)

ecx_include_dirs = cfg["ecx"]["include_dirs"].split(",")
ecx_library_dirs = cfg["ecx"]["library_dirs"].split(",")
ecx_libraries = cfg["ecx"]["libraries"].split(",")



if __name__ == "__main__":

    found_headers = search_headers(ecx_include_dirs, ecx_libraries)
    found_shared = search_libraries(ecx_library_dirs, ecx_libraries, static=False)
    found_static = search_libraries(ecx_library_dirs, ecx_libraries, static=True)

    mod_ext = Extension(name="pyecx._ecx",
                                         sources=["./pyecx/_ecx.c"],
                                         libraries=ecx_libraries,
                                         library_dirs=ecx_library_dirs,
                                         include_dirs=ecx_include_dirs)
    setup(name=mod.__package_name__,
        version=mod.__version__,
        maintainer=mod.__maintainer__,
        maintainer_email=mod.__maintainer_email__,
        author=mod.__author__,
        author_email=mod.__author_email__,
        description=mod.__package_name__,
        long_description=pathlib.Path("README.rst").read_text(encoding="utf-8"),
        url='https://milanskocic.github.io/pyecx/index.html',
        download_url='https://github.com/MilanSkocic/pyecx',
        packages=find_packages(),
        include_package_data=True,
        python_requires='>=3.7',
        install_requires=pathlib.Path("requirements.txt").read_text(encoding="utf-8").split('\n'),
        classifiers=["Development Status :: 4 - Beta",
                    "Intended Audience :: Science/Research",
                    "License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
        ext_modules=[mod_ext]
        )


# pypi
# >>> python setup.py sdist bdist_wheel
# >>> python -m twine upload dist/*
# >>> python -m twine upload --repository testpypi dist/*