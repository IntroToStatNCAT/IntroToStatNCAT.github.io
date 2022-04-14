---
title: "Chapter 7"
subtitle: "Inference for numerical data^[These notes use content from OpenIntro Statistics Slides by Mine Cetinkaya-Rundel.]"
author: |
  | Department of Mathematics & Statistics
  | North Carolina A\&T State University
#date: "8/19/2020"
urlcolor: blue
header-includes:
    \usepackage{multirow}
    \usepackage{graphicx}
    \graphicspath{{images/}}
    \usepackage{subfigure}
    \usepackage{multicol}
    \usepackage[utf8]{inputenc}
    \usepackage[english]{babel}
    \usepackage{bm}
    \usepackage{amsmath}
    \usepackage{tikz}
    \usepackage{mathtools}
    \usepackage{textcomp}
    \usepackage{fdsymbol}
    \usepackage{siunitx}
    \usepackage{xcolor,pifont}
    \usepackage{hyperref}
    \usepackage{mathtools}
output: 
  beamer_presentation:
    fig_caption: true
    latex_engine: xelatex
    
    
---





# Computing the power for a 2-sample test

## 

\begin{center}
\begin{tabular}{l l | c c}
\multicolumn{2}{c}{} & \multicolumn{2}{c}{\textbf{Decision}} \\
& & fail to reject $H_0$ &  reject $H_0$ \\
  \cline{2-4}
& $H_0$ true & \onslide<4->{\textcolor{blue}{$1 - \alpha$}} & \onslide<2->{\textcolor{orange}{Type 1 Error, $\alpha$}} \\
\raisebox{1.5ex}{\textbf{Truth}} & $H_A$ true &  \onslide<3->{\textcolor{orange}{Type 2 Error, $\beta$}} & \onslide<5->{\textcolor{blue}{Power, $1 - \beta$}} \\
  \cline{2-4}
\end{tabular}
\end{center}

\pause

\begin{itemize}
\item Type 1 error is rejecting $H_0$ when you shouldn't have, and the probability of doing so is $\alpha$ (significance level)

\pause 

\item Type 2 error is failing to reject $H_0$ when you should have, and the probability of doing so is $\beta$ (a little more complicated to calculate)

\pause 

\item \textbf{Power} of a test is the probability of correctly rejecting $H_0$, and the probability of doing so is $1 - \beta$

\pause 

\item In hypothesis testing, we want to keep $\alpha$ and $\beta$ low, but there are inherent trade-offs.

\end{itemize}

## Type 2 error rate

If the alternative hypothesis is actually true, what is the chance that we make a Type 2 Error, i.e. we fail to reject the null hypothesis even when we should reject it?

  - The answer is not obvious.
  
  - If the true population average is very close to the null hypothesis value, it will be difficult to detect a difference (and reject $H_0$).
  
  - If the true population average is very different from the null hypothesis value, it will be easier to detect a difference.
  
  - Clearly, $\beta$ depends on the **effect size** ($\delta$).
  
## Example - Blood Pressure (BP), hypotheses

\alert{Suppose a pharmaceutical company has developed a new drug for lowering blood pressure, and they are preparing a clinical trial to test the drug's effectiveness. They recruit people who are taking a particular standard blood pressure medication, and half of the subjects are given the new drug (treatment) and the other half continue to take their current medication through generic-looking pills to ensure blinding (control). What are the hypotheses for a two-sided hypothesis test in this context?}

\pause 

\begin{align*}
H_0&: \mu_{treatment} - \mu_{control} = 0 \\
H_A&: \mu_{treatment} - \mu_{control} \ne 0  
\end{align*}

## Example - BP, standard error

\alert{Suppose researchers would like to run the clinical trial on patients with systolic blood pressures between 140 and 180 mmHg. Suppose previously published studies suggest that the standard deviation of the patients' blood pressures will be about 12 mmHg and the distribution of patient blood pressures will be approximately symmetric. If we had 100 patients per group, what would be the approximate standard error for difference in sample means of the treatment and control groups?}

\pause

\centering{$SE = \sqrt{\frac{12^2}{100} + \frac{12^2}{100}} = 1.70$}

## Example - BP, minimum effect size required to reject $H_0$

\alert{For what values of the difference between the observed averages of blood pressure in treatment and control groups (effect size) would we reject the null hypothesis at the 5\% significance level?}

\pause

![](power_null_B_0_1-7_with_rejection_region.pdf){height="50%"}

\pause

The difference should be at least

\centering{$1.96 \times 1.70 = 3.332.$}

\raggedright or at most

\centering{$-1.96 \times 1.70 = -3.332.$}


## Example - BP, power

\alert{Suppose that the company researchers care about finding any effect on blood pressure that is 3 mmHg or larger vs the standard medication. What is the power of the test that can detect this effect?}

\pause

![](power_null_C_0_1-7_with_alt_at_3.pdf){height="50%"}

\pause

\centering{$Z = \frac{-3.332-(-3)}{1.70} = 0.20$}

\pause

\centering{$P(Z < -0.20) = 0.4207$}

## Example - BP, required sample size for 80% power

\alert{What sample size will lead to a power of 80\% for this test?}

\pause

![](power_null_0_0-76_with_alt_at_3_and_shaded.pdf){height="50%"}

\pause

\centering{$SE = \frac{3}{2.8} = 1.07142$}

\pause

\centering{$1.07142 = \sqrt{\frac{12^2}{n} + \frac{12^2}{n}}$}

\pause

\centering{$n = 250.88 \rightarrow n \geq 251$}

## Recap

- Calculate required sample size for a desired level of power.

- Calculate power for a range of sample sizes, then choose the sample size that yields the target power (usually 80% or 90%).

![](power_curve_neg-3.pdf){height="70%"}

## Achieving desired power

There are several ways to increase power (and hence decrease type 2 error rate):

\pause

\begin{enumerate}

\item Increase the sample size.

\pause

\item Decrease the standard deviation of the sample, which essentially has the same effect as increasing the sample size (it will decrease the standard error). With a smaller $s$ we have a better chance of distinguishing the null value from the observed point estimate. This is difficult to ensure but cautious measurement process and limiting the population so that it is more homogeneous may help.

\pause

\item Increase $\alpha$, which will make it more likely to reject $H_0$ (but note that this has the side effect of increasing the Type 1 error rate).

\pause

\item Consider a larger effect size. If the true mean of the population is in the alternative hypothesis but close to the null value, it will be harder to detect a difference.

\end{enumerate}
