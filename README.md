# RovHer: heritability-optimized scores for the functional prioritization of rare missense variants

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Best-README-Template</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>See training data »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View paper</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</div>



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

Predicting rare variants (RVs; MAF < 1%) that influence complex disease risk is a significant challenge. Missense RVs exhibit a wide range of effects on traits, largely by acting in a polygenic manner, thus the need for tools to better interpret their impact. We introduce RovHer (RV heritability-optimized scores), an unbiased, scalable method that scores missense RVs based on their probability of functional effect.
The RovHer method employs the multivariate adaptive regression splines (MARS) model to integrate feature annotations with exome-wide association study (ExWAS) summary statistics of height. Specifically, it is trained on the RV association false discovery rate retrieved from [Genebass](https://app.genebass.org/), a surrogate measure for the likelihood of variant functionality.

This approach was chosen to directly assess how well each model maximizes the genome-wide phenotypic variance that can be explained by a set of prioritized RVs, which are more likely to be functional and disease-relevant. RovHer scores are trait-agnostic, and the model does not rely on assumptions about genetic architecture or effect size.

![Workflow Overview](RovHer%20workflow.png)
*An overview of the development and application of the RovHer algorithm.*

### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Here are a few examples.

* [![Next][Next.js]][Next-url]
* [![React][React.js]][React-url]
* [![Vue][Vue.js]][Vue-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

This repo allows users to either obtain pre-computed RovHer scores for UK Biobank rare variants. 
Or download a local copy up of the pre-trained RovHer model and generate RovHer scores for a list of RVs following these simple steps.

## System requirements
RovHer can generate variant-level predictions on major operating systems, including GNU/Linux, macOS, and Windows. For biobank-scale analyses, we recommend Unix-based hardware with a minimum of 100GB RAM. 

### Prerequisites

Other required software dependencies for RovHer include the R packages data.table, tidyverse, and dplyr. 
Install the latest version of this package by entering the following in R:
* earth: Multivariate Adaptive Regression Splines. See ([CRAN](https://CRAN.R-project.org/package=earth)).
  ```sh
  install.packages("earth")
  ```

## RovHer predictors

12 significant variant and gene-level predictors selected by the RovHer model
| Importance Ranking | Predictor |
|-----:|-----------|
|     1| Minor allele frequency|
|     2| H3K9ac signals    |
|     3| AlphaMissense       |
|     4| Promoter CpG density    |
|     5| HIPred       |
|     6| Gene expression level    |
|     7| DANN       |
|     8| Promoter phastcons    |
|     9| UNEECON-G       |
|     10| Fathmm-XF      |
|     11| Exonic phastcons      |
|     12| BayesDel-addAF  |

### Installation

_Below is an example of how you can instruct your audience on installing and setting up your app._

1. Get pre-trained model at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Resources

Use the `README.md` to get started.


<!-- USAGE EXAMPLES -->
## Resources

RovHer scores for all UK Biobank 4,927,152 rare variants used in this manuscript, along with pre-computed scores for all possible rare variants in the human exome, will be made available upon publication and can be downloaded from Zenodo. Additionally, pre-trained RovHer models are also available on Zenodo to allow replication and application to other datasets.

Additional screenshots, code examples and demos work well in this space. 
_Please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Chinese
    - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).
<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

