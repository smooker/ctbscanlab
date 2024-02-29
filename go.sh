#!/bin/bash

reset;./test.pl;gnuplot ./gnuplot.txt
ps2pdf printme.ps
