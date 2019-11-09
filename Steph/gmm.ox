#include "../../Documents/Github/niqlow/Steph/BLPMain.ox"

gmm(theta2)
{
	decl theta1c
	theta1c = (X1'*Z*Z*W*Z'*X1)*X1'*Z*W*Z'*delta(theta2)
}