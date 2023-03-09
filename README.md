# ARTwarp 

ARTwarp is a MATLAB-based programme for the automated categorisation of tonal
animal sounds. It has been tested successfully [3] for bottlenose dolphin whistles
and killer whale calls, but will be applicable to any sound that can be
described by frequency contours.

The categorisation algorithm combines dynamic time-warping [1] to measure contour 
similarity with an Adaptive Resonance Theory (ART) neural network to group sounds 
into different categories. The programme provides categorisation details, as well 
as a reference contour representing the typical frequency shape of each category.

The code has been run successfully using Matlab 2016a and 2016b.

- `ARTwarp_csv.m` provides the option to open `.ctr` (Beluga) and `.csv` files

- `ARTwarp_txt.m` provides the option to open `.ctr` (Beluga), `.csv`, and also `.txt` files

This version of `ARTwarp_txt` displays the iteration number and number of whistles 
analysed in the command window while ARTwarp is running. It saves the results at 
the end of each iteration.

For further instructions on installing MATLAB and running ARTwarp, see 
the ARTwarp Wiki: https://github.com/dolphin-acoustics-vip/artwarp/wiki


## Resources

- Source code repository: https://github.com/dolphin-acoustics-vip/artwarp

- Issue tracker: https://github.com/dolphin-acoustics-vip/artwarp/issues

- Wiki: https://github.com/dolphin-acoustics-vip/artwarp/wiki


## Authors

- Volker Deecke: 
  - https://www.cumbria.ac.uk/study/academic-staff/all-staff-members/volker-deecke.php

- Vincent Janik:
  - http://www.smru.st-andrews.ac.uk/person/vj/

with contributions by

- Julie Oswald:
  - https://www.st-andrews.ac.uk/biology/people/jno

- Members of the Dolphin Acoustics Vertically Integrated Project
  at the University of St Andrews:
  - https://dolphinacoustics.wp.st-andrews.ac.uk

- Wendi Fellner


## License

ARTwarp is distributed under the terms of the GNU Lesser General Public
License, version 3, as published by the Free Software Foundation. For
details, please refer to the LICENSE file in the root directory of the
ARTwarp distribution or see https://www.gnu.org/licenses/lgpl.


## References

1. Buck, J. R. & Tyack, P. L. 1993. A quantitative measure of similarity for 
Tursiops truncatus signature whistles. Journal of the Acoustical Society of 
America, 94, 2497-2506. https://doi.org/10.1121/1.407385 

2. Deecke, V. B., Ford, J. K. B. & Spong, P. 1999. Quantifying complex patterns 
of bioacoustic variation: Use of a neural network to compare killer whale 
(Orcinus orca) dialects. Journal of the Acoustical Society of America, 105, 
2499-2507. https://doi.org/10.1121/1.426853 

3. Deecke, V. B. & Janik, V. M. 2006. Automated categorization of bioacoustic
signals: Avoiding perceptual pitfalls. Journal of the Acoustical Society of
America, 119, 645-653. https://doi.org/10.1121/1.2139067