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

Predicting rare variants (RVs; MAF < 1%) that influence complex disease risk is a significant challenge. We introduce RovHer (RV heritability-optimized scores), an unbiased, scalable method that scores missense RVs based on their probability of functional effect. The RovHer method employs the [Multivariate Adaptive Regression Splines](https://CRAN.R-project.org/package=earth) [1] model to integrate feature annotations with [Genebass](https://app.genebass.org/) [2] exome-wide association study (ExWAS) summary statistics of height. Specifically, it is trained on the per-variant false discovery rate, a surrogate measure for the likelihood of variant functionality.

*Performance*:
The model prioritizes RVs based on maximizing the proportion genome-wide phenotypic variance explained, which are variants that more likely functional and disease-relevant [3]. RovHer scores are trait-agnostic, and the model does not rely on assumptions about genetic architecture or effect size. 

*Note on usage*:
RovHer scores were generated on all 79,971,228 possible autosomal rare variants in humans. In our study, the scores were optimized for rare missense variants. LoF variants do not contribute a large proportion of total rare variant heritability of a given trait. 

![Workflow Overview](RovHer%20workflow.png)
*An overview of the development and application of the RovHer algorithm.*

## Requirements
# Hardware
RovHer can generate variant-level predictions on major operating systems, including GNU/Linux, macOS, and Windows. For biobank-scale analyses, we recommend Unix-based hardware with a minimum of 200GB RAM. 

# Software dependencies
R packages data.table, tidyverse, and dplyr

<!-- GETTING STARTED -->
## Getting started: Retrieve pre-computed scores 

This repo allows users to obtain RovHer scores under two options:

| Option | Description | Script name |
|-----:|-----------|-----------|
|     1| Retrieve scores for a given list of rare variants | get_scores.r |
|     2| Retrieve scores for all rare variants in a given gene | get_scores_per_gene.r |

Variant order in `input_variants.txt` does not matter. A text file consisting of a column of PLINK IDs is required for input. No header needed.
| Variants |
|-----:|
|  1:10030:A:T| 
|  8:203440:G:C| 
|  ....| 

1. Clone the repo
   ```sh
   git clone https://github.com/Keonapang/RovHer.git
   cd ./RovHer
   ```
2. Download `All_RovHer_Scores.txt.gz` from Zenodo and place it in the same directory as this script. 

3. Run script. 
   ```sh
    INFILE="./RovHer/Demo/input_variants.txt"
    DIR_OUT="./RovHer/Demo"

    cd ./RovHer
    Rscript ./scripts/get_RovHer_scores.r $INFILE $DIR_OUT
    ``` 

4. Retrieve all RovHer scores for a given gene. Navigate to script directory.
   ```sh
    gene="LDLR"
    DIR_OUT="./RovHer/Demo"

    cd ./RovHer
    Rscript ./scripts/get_RovHer_scores.r $gene $DIR_OUT
    ``` 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Resources -->

## Resources

RovHer scores for all UK Biobank 4,927,152 rare variants used in this manuscript, along with pre-computed scores for all 79,971,228 possible autosomal rare variants in the human exome, will be made available upon publication and can be downloaded from Zenodo. 

RovHer scores:
* Score file generated using a MARS model
* Score file generated using a MARS model trained on prediction features that do not have commercial licensing requirements

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## Acknowledgements

We gratefully acknowledge and thank the authors of the various in silico tools that we utilized in our study for making their pre-computed scores and training data readily available.
* [![Next][Next.js]][Next-url]


## References

[1] Milborrow, S. (2023, January 26). earth: Multivariate Adaptive Regression Splines

[2] Karczewski, K. J., Solomonson, M., Chao, K. R., Goodrich, J. K., Tiao, G., Lu, W., Riley-Gillis, B. M., Tsai, E. A., Kim, H. I., Zheng, X., Rahimov, F., Esmaeeli, S., Grundstad, A. J., Reppell, M., Waring, J., Jacob, H., Sexton, D., Bronson, P. G., Chen, X., … Neale, B. M. (2022). Systematic single-variant and gene-based association testing of thousands of phenotypes in 394,841 UK Biobank exomes. Cell Genomics, 2(9), 100168. https://doi.org/10.1016/j.xgen.2022.100168

[3] Pathan, N., Deng, W. Q., Khan, M., Scipio, M. D., Mao, S., Morton, R. W., Lali, R., Pigeyre, M., Chong, M. R., & Paré, G. (2022). A method to estimate the contribution of rare coding variants to complex trait heritability. Nature Communications, 15(1), 1245. https://doi.org/10.1038/s41467-024-45407-8

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

