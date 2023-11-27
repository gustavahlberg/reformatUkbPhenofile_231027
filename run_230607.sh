#
#
# A) Make H5 files of ukbb phenotype file
# B) add new baskets to existing H5 file
#
# 1) Refresh basket: ukb670531
# 2) 2nd & 3rd basket:(exome fields)
#
# ----------------------
#
# configs
#

screen -S h5generate

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
PATH=${PATH}:${DIR}/bin
#UKBB=/home/projects/cu_10039/data/UKBB
PHENO=${DIR}/../../data/PHENOTYPE/


# -----------------------------------------                 
#                                                           
# Start: 1) Refresh Intial basket:
#                                                           

echo "running ukb673220"
ukbPheno_fn=${PHENO}/ukb673220.tab
ukbMeta_fn=${PHENO}/ukb673220.html
initial="TRUE"                                              
ukbAdd_h5="None"                                            
                                                            
Rscript Main.R $ukbPheno_fn $ukbMeta_fn $initial $ukbAdd_h5 
                                                            

                                                            
# -----------------------------------------                 
#                                                           
# 2) add hessian
#


echo "running ukb."
ukbPheno_fn=${PHENO}/ukb673631.tab
ukbMeta_fn=${PHENO}/ukb673220.html
initial="FALSE"                                             
ukbAdd_h5=${PHENO}/ukb673220.all_fields.h5
                                                            
Rscript Main.R $ukbPheno_fn $ukbMeta_fn $initial $ukbAdd_h5 

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################



