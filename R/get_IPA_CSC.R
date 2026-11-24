get_IPA_CSC <- function(IPA_CSC_data, covars){
    midpoint <- nrow(IPA_CSC_data) %/% 2L
    train <- IPA_CSC_data[seq_len(midpoint), ]
    test <- IPA_CSC_data[seq.int(midpoint + 1L, nrow(IPA_CSC_data)), ]
    ff <- as.formula(paste("Hist(study_time_num, new_event) ~", paste(covars, collapse, = '+')))
    csc_model <- CSC(formula = ff, data = train)
    x <- riskRegression::Score(list(csc_model),
                                data = test,
                                formula = Hist(study_time_num, new_event) ~ 1,
                                times = 1826.25,
                                summary = "IPA",
                                metrics = "brier",
                                contrasts = FALSE,
                                se.fit = FALSE)
    return(x)
}
