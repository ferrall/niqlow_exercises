#include "oxstd.h"
#include "gmmreduced.ox"
#import "maximize"

main() {
 savemat("BLP2.in7",loadmat("../../../../Desktop/Empirical Methods/PS1_Data/OTCreduced.xlsx"));  //this loads the data as a matrix

 loaddata();
 decl 	theta2 = <0.7, 0.08>, fval ;
 MaxSimplex(gmmreduced,&theta2,&fval,0); 
}