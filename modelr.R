library(devtools)
gh_install_packages("Model-R/modelr_pkg", build_vignettes = TRUE)
#install.packages(xxx)#soon!
library(ModelR)
library(rJava) 
library(raster)
library(dismo)

################################ Import occurence records
pres <- read.csv(file.choose(), header=T) # carrega o arquivo .csv em um novo objeto, "pres"
pres # visualizar todas as linhas do arquivo carregado
head(pres) # visualizar primeiras linhas do arquivo carregado

pres <- pres[ ,2:3] # seleciona apenas as colunas 2 e 3 do arquivo (lon e lat)
head(pres)

###################################  Bioclimatic data and Rasterstack transformation to make usable

predictors <- list.files(path=paste('c:/models_dir/layers', sep=''), pattern='bio', full.names=TRUE )
predictors <- stack(predictors)
predictors

################## Samples pseudoabsences inside a geographic buffer

final_points <- setup_sdmdata(species_name = pres[1],
                             occurrences = pres,
                             predictors = predictors,
                             clean_nas = T,
                             models_dir = "modelR_test",
                             lon = "lon",
                             lat = "lat",
                             partition_type = "crossvalidation",
                             cv_partitions = 5,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "distance",
                             dist_buf = 100,
                             geo_filt = T,
                             geo_filt_dist = 100,
                             plot_sdmdata = T,
                             n_back = 500)