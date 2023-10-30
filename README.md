# GradientReconstruction_2D_Public
 Patricle tracking with Full gradient reconstruction. Pubic access.

Chi Zhang, Physics department, Fribourg University, Switzerland
chi.zhang2@unifr.ch
Oct, 2023clear

# GetBackground.m
It averages images without particle to get the background of the Roi. For images with structure (pattern) in the background, this is useful.

# Get_2D_profile.m
It averages images with 1 particle to get the intensity profile and gradient in x and y (Shape function). Remove of background is optional.

# GradientReconstruction_2DProfile_1p.m
# GradientReconstruction_2DProfile_2p.m
They take the obtained Graident/Intensity Profile and the background(optional) to fit the images (1p or 2p).
Position Size(relative to The Profile (Shape function)) and intensity are extracted from the fit.


# Remarks
It is straight forward to upgrade to track more than 2 particles.
It is possible to obtain the Shape function directly from the images with multiple particles.
Please contact the author if you need help.
