
<!-- README.md is generated from README.Rmd. Please edit that file -->

# socialrisk

<!-- badges: start -->

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/socialrisk)](https://cran.r-project.org/package=socialrisk)
![CRAN_Download_Counter](http://cranlogs.r-pkg.org/badges/grand-total/socialrisk)
<!-- badges: end -->

The goal of `socialrisk` is to create an efficient way to identify
social risk from administrative health care data using ICD-10 diagnosis
codes.

## Installation

You can install `socialrisk` from CRAN with:

``` r
install.packages("socialrisk")
```

The development version of `socialrisk` can be downloaded from
[GitHub](https://github.com/WYATTBENSKEN/socialrisk) with:

``` r
# install.packages("devtools")
devtools::install_github("WYATTBENSKEN/socialrisk")
```

## Background on Social Risk and Z-Codes

With the introduction of the 10th Revision of the International
Classification of Disease (ICD-10) in 2015 came a new class of codes,
which start with the letter Z and thus are referred to as Z-codes which
aimed to allow for care providers to capture social factors of their
patients. These codes include factors which influence health and health
outcomes such as homelessness or housing insecurity, unemployment, low
education, and economic concerns. As these were ICD-10 codes they
followed a standard format as all other diseases and start with the
letter Z and thus are referred to as Z-codes. Since their implementation
they’ve attracted substantial attention from policy makers and health
care leaders as a potential mechanism to document and report a practice
or system’s patient needs, as well as a mechanism to adjust purchasing
or payment programs.

Z-codes have been referred to as both “social determinants of health” as
well “health-related social needs.” While oftentimes used
interchangeably, these are distinct constructs and the lexicon around
this has been of high attention recent. From this work, we first note
that social determinants of health (SDoH) operate at the community
level. These are the characteristics of the collective community,
neither positive nor negative, which can affect health.15,16 When SDoH
are adverse they engender social risk factors for individuals within the
community. However, not every patient will identify or prioritize a
social risk as a need that must be tended to. When a patient identifies
a social risk factor as a priority for which assistance is needed, that
risk becomes a need termed a health-related social needs (HRSN).

There is notable divergence in the literature around which Z codes, and
their conceptual domains, are part of social risk/social need analyses.
First, CMS in their work has included Z55 through Z65 as the relevant Z
codes to capture HRSN. This range of codes was expanded on by the
Missouri Hospital Association to create 5 domains distinct domains
(socioeconomic status, employment, housing, family and psychosocial),
which have subsequently been used in additional studies. Finally, the
third source which has provided a list and domains for Z codes is the
Social Interventions Research and Evaluation Network (SIREN) at the
University of California San Francisco. In the SIREN Compendium, which
includes both ICD codes as well as HRSN codes for other taxonomies,
there is a much wider range of ICD Z-codes, beyond Z55-Z65 that are
included.

This package allows one to implement any three of these approaches and
taxonomies in their data using ICD-10 Z-codes to allow for flexibility
and efficiency in identifying social risk and social needs from
administrative claims data.

## Package and Function Options

### Data Cleaning

This package includes a `clean_data()` function which allows us to
obtain a cleaned dataset by specifying the dataset name, patient ID
variable, whether the data is wide (multiple diagnosis columns) or long
(single diagnosis column), as well as the prefix of the diagnoses
columns. It’s recommended that this is run on all datasets to prepare
them for then running the `socialrisk()` function.

``` r
clean_data(dat = i10_wide, id = patient_id, style = "wide", prefix_dx = "dx")
```

### Social Risk Codes

There are three different taxonomies built into `socialrisk()` which are
called with the `taxonomy` argument as such:

``` r
socialrisk(dat = data, id = id, dx = dx, taxonomy = "cms")
socialrisk(dat = data, id = id, dx = dx, taxonomy = "mha")
socialrisk(dat = data, id = id, dx = dx, taxonomy = "siren")
```

| Taxonomy | Link                                                                                                                                                                               | Description                                                                                                                                                               |
|:---------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cms`    | [Using Z Codes](https://www.cms.gov/files/document/zcodes-infographic.pdf)                                                                                                         | CMS has identified Z55-Z65 as the Z-codes for social risk, however they have not placed them into conceptual categories. In this package we use the parent code to do so. |
| `mha`    | [Decoding the Social Determinants of Health](https://www.mhanet.com/mhaimages/Policy_Briefs/PolicyBrief_SDOH.pdf)                                                                  | The Missouri Hospital Association uses the same set of codes as CMS, but has put them into 5 conceptually meaningful categories, separate from the parent codes.          |
| `siren`  | [Compendium of medical terminology codes for social risk factors](https://sirenetwork.ucsf.edu/tools-resources/resources/compendium-medical-terminology-codes-social-risk-factors) | The SIREN compendium uses a broader range of codes (beyond Z-codes), has a larger number of conceptual categories, but notably excludes occupational exposures.           |

Please see the vignette for greater details on how to implement these
functions.
