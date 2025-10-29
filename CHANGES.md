# ARTwarp - history of changes

## ARTwarp v1.1

This release focusses on bug fixes and improved documentation.

### New features

- Added a constant field 'id' to the DATA table. This is the basis for future interfacing with OCEAN,
but does not otherwise change the outputs produced [#72]

### Fixed bugs that could lead to incorrect results

- Fixed warp.m so that changing warpFactorLevel correctly changes the
maximum warping factor allowed [#77]

### Fixed bugs that could lead to crashes

- Ensured support of ctr files made by Beluga [#74]

### Other changes

- Moved some code from .mat files and add .mat files to .gitignore [#83]


## ARTwarp v1.0

This is the first release made from the GitHub repository after its
establishment, initially populating the repository with the content of 
historic archives:

- Version of 2003-11-25 ([417b267](https://github.com/dolphin-acoustics-vip/artwarp/commit/417b2673ec2a2b3fb55e8950ca89121665c9666c))

- Version of 2019-01-11 ([953944e](https://github.com/dolphin-acoustics-vip/artwarp/commit/953944e967123f3b847d213d7c64ac43ed9146f9))

- Version of 2021-10-01 ([fce0bc6](https://github.com/dolphin-acoustics-vip/artwarp/commit/fce0bc61534de3a055cb7b143dd6e321de94b9d6))