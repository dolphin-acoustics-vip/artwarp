# ARTwarp - history of changes

## ARTwarp v2.0

This release focuses on the addition of a Command Line Interface (CLI) as a faster and safer alternative to running ARTwarp through the Graphical User Interface (GUI). It also includes a new categorisation options to maximise preservation of 'stepped' whistle shapes.

### New features

- Added a Command Line Interface (CLI) so ARTwarp can be run through the command line. This allows for the ability to automate computational workflows, and also decreases runtime by skipping the generation of graphical objects for the GUI. Instructions for running can be found at the README [here](https://github.com/dolphin-acoustics-vip/artwarp?tab=readme-ov-file#artwarp-cli-mode). This feature was added in [#93](https://github.com/dolphin-acoustics-vip/artwarp/pull/93)

- Added option to update reference contours (weights) according to time-warped input contours, i.e. do not unwarp reference contours when learning. Instead, reference contours are interpolated to the mean length of contours in their category at the end of each iteration. This can help to preserve 'stepped' frequency modulation patterns [#94](https://github.com/dolphin-acoustics-vip/artwarp/pull/94)

### Improved and extended functionality

- Added option to specify output folder when using the CLI [#101](https://github.com/dolphin-acoustics-vip/artwarp/pull/101)

- Added default values and command builder when using the CLI. This allows newer users of ARTwarp to easily use ARTwarp through the CLI, while retaining total control over all network parameters. For usage instructions, again see the README [here](https://github.com/dolphin-acoustics-vip/artwarp?tab=readme-ov-file#artwarp-cli-mode). This feature was added in [#106](https://github.com/dolphin-acoustics-vip/artwarp/pull/106)

- Added option to the GUI to convert contour files from `.csv` to `.ctr`. This option is available under 'file' in the main ARTwarp menu, and removes the need for users to run and modify `TempRes3.m` directly [#104](https://github.com/dolphin-acoustics-vip/artwarp/pull/104)

- Print iteration number, number of reclassified samples, and number of categories at the end of each iteration when running from the CLI. This increases runtime visibility and aids debugging [#113](https://github.com/dolphin-acoustics-vip/artwarp/pull/113)

### Removed or obsolete functionality

- Deleted `ARTwarp_txt.m`, which was non-functional and did not appear to be used [#109](https://github.com/dolphin-acoustics-vip/artwarp/pull/109)

### Fixed bugs that could lead to crashes

- Allow users to load data from folder and file names containing spaces and/or singular quotes. This would previously result in a runtime error. [#96](https://github.com/dolphin-acoustics-vip/artwarp/pull/96)

### Improved testing and error handling

- Added input validation for user-supplied network parameters [#90](https://github.com/dolphin-acoustics-vip/artwarp/pull/90)

- Updated CI setup and restored CodeCov integration [#102](https://github.com/dolphin-acoustics-vip/artwarp/pull/102/changes)

- Added six basic unit tests to CI [#112](https://github.com/dolphin-acoustics-vip/artwarp/pull/112)

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