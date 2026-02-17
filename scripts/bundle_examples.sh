#!/usr/bin/env bash

print_example() {
    while IFS='' read -r lineraw; do
        line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
        echo "        $line"
    done < $1
}

echo "    Example in Fortran:"
echo ""
print_example "example/example.f90"
echo ""

echo "    Example in C:"
echo ""
print_example "example/example.c"
echo ""

echo "    Example in Python:"
echo ""
print_example "example/example.py"
echo ""
