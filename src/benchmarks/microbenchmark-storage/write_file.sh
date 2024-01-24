#!/bin/bash
#write a file

echo "Hello World!" > hello_world.txt

#ensures all pending writes are flushed to the underline storage
sync -f ./hello_world.txt


