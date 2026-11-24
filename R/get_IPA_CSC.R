get_IPA_CSC <- function(IPA_CSC_data, covars){
    train <- IPA_CSC_data[1:floor(nrow(IPA_CSC_data)/2)]
    test <- IPA_CSC_data[floor(nrow(IPA_CSC_data)/2):nrow(IPA_CSC_data)]
    ff <- as.formula(paste("Hist(study_time_num, new_event) ~", paste(covars, collapse, = '+')))
    csc_mode <- CSC(formula = ff, data = train)
    x <- riskRegression::Score(list(csc_model),
                                data = test,
                                formula = Hist(study_time_num, new_event) ~ 1,
                                times = 1826.25
                                summary = "IPA"
                                metrics = "brier"
                                contrasts = FALSE,
                                se.fit = FALSE)
    return(x)
}
