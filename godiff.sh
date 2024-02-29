#!/bin/bash
#
#
hexdump -C 10254358.CTB > 1.hex
hexdump -C result.ctb > 2.hex


vimdiff 1.hex 2.hex
