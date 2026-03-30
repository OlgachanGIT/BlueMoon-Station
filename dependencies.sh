#!/bin/sh

#Project dependencies file
#Final authority on what's required to fully build the project

# byond version
export BYOND_MAJOR=516
export BYOND_MINOR=1680

#rust_g git tag
export RUST_G_VERSION=6.0.1

#node version
export NODE_VERSION_LTS=20.19.0
export NODE_VERSION_COMPAT=20.19.0

# SpacemanDMM git tag
export SPACEMAN_DMM_VERSION=suite-1.11

# Python version for mapmerge and other tools
export PYTHON_VERSION=3.11.0

# Auxmos git tag (releases: https://github.com/Putnam3145/auxmos/releases )
# v2.5.6: reported illegal operation + network sequence errors — avoid until confirmed fixed.
# v2.5.5: SIMD runtime detection, planetary atmos perf fixes; includes bindings.dm in release assets.
export AUXMOS_VERSION=v2.5.5

# Extools git tag
export EXTOOLS_VERSION=v0.0.7
