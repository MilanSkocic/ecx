#!/usr/bin/env bash

for i in doc/*.txt; do name=$(basename -s .txt $i ); echo "- :download:\`$name <../../$name>\`";done
