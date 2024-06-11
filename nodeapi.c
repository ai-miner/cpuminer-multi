#include "miner.h"
#include <stdlib.h>
#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif

void* cipher(char* algo, const void* input){
	void *output;
	cryptolight_hash(output, input);
	return output;
} 

/* void* cipher(char* algo, const void* input){
	printf("cipher===");
	return "xfasdf";
} */


#ifdef __cplusplus
}
#endif