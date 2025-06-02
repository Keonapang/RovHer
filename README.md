# RovHer: heritability-optimized scores for the functional prioritization of rare missense variants

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT -->
## About

Predicting rare variants (RVs; MAF < 1%) that influence complex disease risk is a significant challenge. We introduce RovHer (RV heritability-optimized scores), an unbiased, scalable method that scores missense RVs based on their probability of functional effect. The RovHer method employs the [Multivariate Adaptive Regression Splines](https://CRAN.R-project.org/package=earth) model to integrate feature annotations with [Genebass](https://app.genebass.org/) exome-wide association study (ExWAS) summary statistics of height. Specifically, it is trained on the RV association false discovery rate, a surrogate measure for the likelihood of variant functionality.

We used a heritability-based benchmark approach to directly assess how well the model maximizes genome-wide phenotypic variance that can be explained by a set of prioritized RVs, which are more likely to be functional and disease-relevant. RovHer scores are trait-agnostic, and the model does not rely on assumptions about genetic architecture or effect size.

![Workflow Overview](RovHer%20workflow.png)
*An overview of the development and application of the RovHer algorithm.*

## Hardware requirements
RovHer can generate variant-level predictions on major operating systems, including GNU/Linux, macOS, and Windows. For biobank-scale analyses, we recommend Unix-based hardware with a minimum of 100GB RAM. 

<!-- GETTING STARTED -->
## Getting Started

This repo allows users to obtain RovHer scores. There are two options:

| Option | Description | Software requirements |
|-----:|-----------|-----------|
|     1| Retrieve pre-computed scores generated on UK Biobank WES data | R (3.6>) |
|     2| Generate scores for any given list of rare variants using pre-trained RovHer model | R (3.6>); 'earth' R package (5.3.4) |

Other required software dependencies for RovHer include the R packages data.table, tidyverse, and dplyr. 

# Option 1: Retrieve pre-computed scores 

A text file consisting of a column of PLINK IDs is required for input. 
| Variants |
|-----:|
|  1:10030:A:T| 
|  1:103040:C:G| 
|  8:203440:G:C| 
|  ....| 


# Option 2: Generate scores using pre-trained model

### Installation

1. Download pre-trained model at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/Keonapang/RovHer.git
   ```
3. Install the latest version of [earth: Multivariate Adaptive Regression Splines](https://CRAN.R-project.org/package=earth))
  ```sh
  install.packages("earth")
  ```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Example workflow

Change directories `cd /RovHer`
Access sample training dataset `./input/annotation_matrix.txt` 
Preview sample output file `./output/RovHer_scores.txt`

<!-- Resources -->

## Resources

RovHer scores for all UK Biobank 4,927,152 rare variants used in this manuscript, along with pre-computed scores for all possible rare variants in the human exome, will be made available upon publication and can be downloaded from Zenodo. Additionally, pre-trained RovHer models are also available on Zenodo to allow replication and application to other datasets.

Additional screenshots, code examples and demos work well in this space. 
_Please refer to the [Documentation](https://example.com)_

Pre-trained RovHer models:
* Full model (trained on the FDR of height)
* Model excluding prediction methods with commercial licensing requirements

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## Acknowledgements

We gratefully acknowledge and thank the authors of the various in silico tools that we utilized in our study for making their pre-computed scores and training data readily available.
* [![Next][Next.js]][Next-url]


## References

RARity paper

Milborrow, S. (2023, January 26). earth: Multivariate Adaptive Regression Splines

Karczewski, K. J., Solomonson, M., Chao, K. R., Goodrich, J. K., Tiao, G., Lu, W., Riley-Gillis, B. M., Tsai, E. A., Kim, H. I., Zheng, X., Rahimov, F., Esmaeeli, S., Grundstad, A. J., Reppell, M., Waring, J., Jacob, H., Sexton, D., Bronson, P. G., Chen, X., … Neale, B. M. (2022). Systematic single-variant and gene-based association testing of thousands of phenotypes in 394,841 UK Biobank exomes. Cell Genomics, 2(9), 100168. https://doi.org/10.1016/j.xgen.2022.100168

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

