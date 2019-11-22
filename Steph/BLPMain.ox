#include "oxstd.h"
#include "gmmnew.ox"
#import "maximize"

main() {
 //savemat("BLP.in7",loadmat("../../../../Desktop/Empirical Methods/PS1_Data/OTCnew.xlsx"));  //this loads the data as a matrix

 loaddata();
 decl 	theta2 = <0.7, 0.08>, fval ;
 MaxSimplex(gmmnew,&theta2,&fval,0); 
}
