#include "oxstd.h"
#include "gmmreduced.ox"
#import "maximize"

main() {
// savemat("BLP3.in7",loadmat("../../../../Desktop/PhD Year 2/BLP/BLP/gmmreduced2.xlsx"));  //this loads the data as a matrix

 myload();
 decl 	theta2 = <0.7; 0.08>, fval ;
 println("return code ",MaxSimplex(gmmreduced,&theta2,&fval,0)); 
}