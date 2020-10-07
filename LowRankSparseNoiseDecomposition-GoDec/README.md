# Low Rank Sparse Noise Decomposition - GoDec

## Description

This is the Python 3.7 traduction of the AISTATS 2013 GreBsmo code (Zhou and Tao) available here in its Matlab version :
https://tianyizhou.wordpress.com/2014/05/23/aistats-2013-grebsmo-code-is-released/

More details about the code :
https://nuit-blanche.blogspot.com/2014/07/grebsmo-greedy-bilateral-sketch.html

Our Python version can take 8bit or 16bit TIFF stacks as inputs, and more common .avi movies.
The RGB .avi are converted in grayscale.

## File description

- The Samples folder contains two test files : a .avi movie (Escalator.avi) and a b/w 8bit TIFF stack of the same movie (Escalator-1000f-8b.tif). For space reasons, the TIFF stack contains only the first 1000 frames of the movie.

- GreGoDec.py contains all the functions necessary to perform the LRSE decomposition.

- [requirements.txt](./requirements.txt) summarizes the libraries used and their version

## Installation

### With pipenv

In order to separate the project's dependencies from the ones installed on your computer, it is recommended to use [pipenv](https://pipenv.pypa.io/en/latest/) to install the dependencies.

~~~bash
git clone https://github.com/FattaccioliLab/Codes
cd Codes/LowRankSparseNoiseDecomposition-GoDec
pipenv sync
~~~

This will install the dependencies specified in the `Pipfile.lock` file. You'll need to have python 3.7 installed on your computer.

### With pip (not recommended)

~~~bash
pip install --user -r requirements.txt
~~~

## Usage

~~~bash
# with pipenv
pipenv run python run-example.py
# with pip
python3.7 run-example.py
~~~

Execute the function:

~~~python
DecomposeGoDec(NameFile, rank = 3, power = 5, tau= 7, tol= 0.001, k = 2, dynamicrange = 8, length = 0)
~~~

The output will be 4 TIFF stacks :

- 1-Original.tif : the original TIFF stack or the B/W TIFF version of the .avi movie

- 2-Background.tif : the Low Rank component TIFF stack, corresponding to the background

- 3-Sparse.tif : the Sparse component TIFF file, containing the moving objects of interest

- 4-Noise.tif : the Noise component TIFF file, containing the noisy data from the input movie

The function takes the following arguments :

- Namefile : path of the .avi movie or TIFF stack
- rank : rank(L)<=rank
- tau : soft thresholding
- tol : error tolerance
- power: >=0, power scheme modification, increasing it lead to better accuracy and more time cost
- k : rank stepsize
- dynamicrange : grayscale depth (8 or 16) of the output TIFF files
- length : the number of frames on which to run the routine.

rank, tau, power, tol and k are parameters coming from the code of Zhou and Tao.

## Simple version

> Execute DecomposeGoDec(filename: str)

In this case, the routine works with defaults values (rank = 3, power = 5, tau= 7, tol= 0.001, k = 2, dynamicrange = 8) and all the frames of the stack are considered. The decomposition can be pretty slow if the frame number is > 10^3

> Execute DecomposeGoDec(filename: str, max_frames: int)

In this case, the routine works also with defaults values (rank = 3, power = 5, tau= 7, tol= 0.001, k = 2, dynamicrange = 8) but on the max_frames (int) first frames of the movie

## REFERENCE

Tianyi Zhou and Dacheng Tao, "GoDec: Randomized Lo-rank & Sparse Matrix Decomposition in Noisy Case", ICML 2011

Tianyi Zhou and Dacheng Tao, "Greedy Bilateral Sketch, Completion and  Smoothing", AISTATS 2013.

Python Implementation: J. Fattaccioli (Department of Chemistry, ENS)

Date: March 2020

## Reminders

~~~bash
# generate requirements.txt from Pipfile.lock
pipenv lock --requirement > requirements.txt
~~~
