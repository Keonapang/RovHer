# RovHer: heritability-optimized scores for the functional prioritization of rare missense variants

<!-- TABLE OF CONTENTS -->
<a name="readme-top"></a>
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about">About</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#hardware">Hardware</a></li>
        <li><a href="#software-dependencies">Software Dependencies</a></li>
      </ul>
    </li>
    <li><a href="#usage-retrieve-pre-computed-scores">Usage: Retrieve Pre-computed Scores</a></li>
    <li><a href="#resources">Resources</a></li>
    <li><a href="#acknowledgements">Acknowledgments</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#citing-rovher">Citing RovHer</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>

<!-- ABOUT -->
## About

Predicting **rare variants** (RVs; MAF < 1%) that influence complex disease risk is a significant challenge. We introduce **RovHer** (RV heritability-optimized scores), an unbiased, scalable method that scores missense RVs based on their probability of functional effect. RovHer employs the [Multivariate Adaptive Regression Splines](https://CRAN.R-project.org/package=earth) [1] model to integrate feature annotations with [Genebass](https://app.genebass.org/) [2] (N=394,841) exome-wide association study (ExWAS) summary statistics of height, which serves as the training trait. The dependent variable for training is the per-variant **false discovery rate**, a surrogate measure for the likelihood of variant functionality.

**Performance**:
* prioritizes RVs that explain the largest proportion of genome-wide phenotypic variance, which are variants that more likely functional and disease-relevant [3]

**Usage**:
* scores are trait-agnostic (i.e. not tied to a specific disease or phenotype)
* while RovHer scores were generated for *all* RVs, they are optimized for missense RVs, which were shown to be significantly enriched in RV heritability across 21 quantitative traits tested in the Uk Biobank.

![Workflow Overview](RovHer%20workflow.png)
*An overview of the development and application of RovHer.*

# Getting started
### Hardware
RovHer can generate predictions on major operating systems, including GNU/Linux, macOS, and Windows. For biobank-scale analyses, we recommend Unix-based hardware with a minimum of 100GB RAM.

### Software dependencies
R packages data.table, tidyverse, and dplyr.

<!-- Usage: Retrieve pre-computed scores -->
# Usage: Retrieve pre-computed scores 

One text file (`input_variants.txt`) consisting of a column of PLINK IDs (no headers) is required for input. Variant order does not matter.
|             |
|-------------|
|  1:10030:A:T| 
|  8:203440:G:C| 

1. Clone the repo
   ```sh
   git clone https://github.com/Keonapang/RovHer.git
   cd ./RovHer
   ```
2. Download `All_RovHer_Scores.txt.gz` from Zenodo and place it in the same directory as this script.

3. Run script to obtain RovHer scores in two ways:

| Option | Description | Script name |
|--:|-----------|-----------|
|  A| Retrieve scores for a given list of rare variants | `get_scores.r` |
|  B| For a given protein-coding gene, retrieve all rare variants with RovHer scores | `get_scores_per_gene.r` |

For **option A**, run:
   ```sh
    INFILE="./RovHer/Demo/input_variants.txt" # modify
    DIR_OUT="./RovHer/Demo" # modify

    cd ./RovHer # Navigate into the directory of this cloned git repo 
    Rscript ./Scripts/get_scores.r $INFILE $DIR_OUT
  ```

For **option B**, run:
  ```sh
    GENE="LDLR" # modify 
    DIR_OUT="./RovHer/Demo" # modify

    cd ./RovHer # Navigate into the directory of this cloned git repo 
    Rscript ./Scripts/get_scores_per_gene.r $GENE $DIR_OUT
  ``` 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Resources -->

# Resources

RovHer scores for all UK Biobank 4,927,152 rare variants used in this manuscript, along with pre-computed scores for all 79,971,228 possible autosomal rare variants in humans, will be made available to download on Zenodo upon publication.

We also provide another set of 79,971,228 scores that was not trained on prediction features that have commercial licensing requirements.

<!-- Acknowledgements -->
## Acknowledgements

We gratefully acknowledge and thank the authors of various in silico tools that we utilized in our study for making their pre-computed scores and training data readily available.

## References

[1] Milborrow, S. (2023, January 26). earth: Multivariate Adaptive Regression Splines

[2] Karczewski, K. J., Solomonson, M., Chao, K. R., Goodrich, J. K., Tiao, G., Lu, W., Riley-Gillis, B. M., Tsai, E. A., Kim, H. I., Zheng, X., Rahimov, F., Esmaeeli, S., Grundstad, A. J., Reppell, M., Waring, J., Jacob, H., Sexton, D., Bronson, P. G., Chen, X., … Neale, B. M. (2022). Systematic single-variant and gene-based association testing of thousands of phenotypes in 394,841 UK Biobank exomes. Cell Genomics, 2(9), 100168. https://doi.org/10.1016/j.xgen.2022.100168

[3] Pathan, N., Deng, W. Q., Khan, M., Scipio, M. D., Mao, S., Morton, R. W., Lali, R., Pigeyre, M., Chong, M. R., & Paré, G. (2022). A method to estimate the contribution of rare coding variants to complex trait heritability. Nature Communications, 15(1), 1245. https://doi.org/10.1038/s41467-024-45407-8

<!-- Citing -->
## Citing RovHer

If you use RovHer in your research, please cite our paper (citation details will be added upon publication). 

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
