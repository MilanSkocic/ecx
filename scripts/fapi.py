#!/usr/bin/env python
"""Extract Fortran API for man pages."""
from typing import List
import argparse
from sphinx_fortran_domain.lexers.lexer_regex import RegexFortranLexer

o1 = "    o "
o2 = "        o "

def olist(n=1):
    o = "    "*n + "o "
    return o

def main(files:List, n=1):
    lexer = RegexFortranLexer()
    res = lexer.parse(files, doc_markers=["!", ">"])
    
    for name in res.modules:
        mod = res.modules[name]
        for p in mod.procedures:
            if p.doc is None:
                doc = "  ---"
            else:
                doc = p.doc

            print(olist(n) + p.signature + "  " + doc.replace("!","  "))
            for arg in p.arguments:
                if arg.doc is None:
                    doc = "  ---"
                else:
                    doc = arg.doc
                print(olist(n+1) + arg.decl + "::" + arg.name + "  " + doc.replace("!","  "))

    


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="fapi", 
                                     description="Extrac Fortran API for man pages.")

    parser.add_argument("file", nargs="+", type=str, help="file to process")
    parser.add_argument("--n", type=int, required=False, default=1, help="Shift list by n.")
    
    args = parser.parse_args()

    main(args.file, args.n)
