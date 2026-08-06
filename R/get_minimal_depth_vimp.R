#Functio for extracting per-variable average first-order minimal depth from rfsrc object.
if(FALSE){
  
}

get_minimal_depth_vimp <- function(rf_model_bin){
  md <- max.subtree(rf_model_bin)$order
  out <- md[,1]
  return(out)
}