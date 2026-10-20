# Outline of article: Case study on Random Survival Forests for Variable Importance ranking of ECG variables for OHCA risk assessment

## Motivation
In concrete applications cause-specific Cox models may have difficulty identifying important effects.
The model may be misspecified.
Groups of variables that may be collectively important may be considered unimportant if explanatory power is spread between them.
Interaction effects quickly become intractable to compute as the number of variables grow.
Some applications simplify the situation by only considering the effect of a single exposure for an otherwise healthy population.
Following a recent paper investigating the effect of ECG variables of OHCA in terms of ATE within a Cox model relative to a healthy population, we consider the problem through a non-parametric lens by using random survival forests as outcome models and investigating a range of variable imporatnce measures.

## I: How much predictive information is contained in the ECG variables
First, we wish to know to what degree ECG variables contain predictive information for OHCA incidence, relative to demographic, comorbidity and medication use variables (background variables).
For a given model, we quantify predictive power added by ECG variables as the difference in IPA (Index of Prediction Accuracy) of the model with and without the ECG variables respectively.

## II: How great is the variability of variable importance measures for random survival forests?
Variable importance measures for random survival forest introduce variance at multiple levels.
Since theoretical results are lacking, we investigate by MC simulation.
For a given setting, we will fit random forests, compute vimps and compute cumulative average rank and variance of rank for each variable until the MC average and variance stabilize.
We may conduct the MC procedure for a number of relevant hyperparameter settings.

## III: Highly correlated variables and variable groups
We will investigate whether grouping of highly correlated variables into variable clusters can overcome any of the problems currently faced, and if so, how to decide on varaible groupings for a particular problem.
Strobl et al define conditional permutation importance as a way of maintaining the correlation structure of the data when permutation importance is evaluated.
This allows a notion of variable importance relative to a set of conditioning variables.
Perhaps a fruitful notion of "variable substitutability" is the contrast between marginal permutation vimp and conditional permutation VIMP. 
If indeed ranking importance of varialbe clusters, rather than particular variables, proves fruitful, we are confronted by the following question:
How do we identify relevant interventions on variable clusters?

## IV: Ensemble VIMP
Is there something to be gained from combining different variable importance measures?
A particular point of interest is handling continuous vs. categorical variables.

### Idea for ensemble VIMP
If the task of variable importance ranking can be decomposed into partial tasks, we might use different variable importance measures/procedures for each task.
We imagine a situation with a large number of variables where most have no effect, and where many variables are clustered in correlated groups.
A concrete suggestion for variable importance ranking task decomposition:
1. Variable grouping (to retain important factors measured in a multitude of ways)
2. Group selection (to remove groups that are unimportant to reduce noise)
3. Group ranking (to provide the final ranking of factor importance)

### Idea for combining lists
The superRanker article defines a metric on ordered lists.
Can we construct a "list regression" procedure by minimizing this metric between an "estimated best list" and a set of "data lists" arising from different procedures?
If so, we might develop a "superImportance" method to handle various issues in data structures.