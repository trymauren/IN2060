#include "fft.h"

/**
 * This file contains the implementation of `fft_compute` and ancillary
 * functions.
 */

// Include for math functions and definition of PI
#include <math.h>
// Included to get access to `malloc` and `free`
#include <stdlib.h>

complex* precalc_twiddles(int n){
	int half = n/2;
	complex mult = (2. * M_PI * I)/n;
	complex* twiddles = malloc(sizeof(complex)*half);
	
	for(int i = 0; i < half; ++i){
		twiddles[i] = cexp(0 - mult * i);
	}
	return twiddles;
}


void fft_compute_req(const complex* in, complex* out, const int n, int s, complex* twiddles){
	if(n == 1) {
		out[0] = in[0];
	} else {
		const int half = n / 2;
		// Recursively calculate the result for bottom and top half
		fft_compute_req(in, out, half, s*2, twiddles);
		fft_compute_req(in + s, out + half, half, s*2, twiddles);
		
		// Combine the output of the two previous recursions
		for(int i = 0; i < half; ++i){
			const complex e = out[i];
			const complex o = out[i+half];
			const complex w = twiddles[i * s];
			out[i]        = e + w*o;
			out[i + half] = e - w*o;
		}
	}  
}

void fft_compute(const complex* in, complex* out, const int n){
	complex* twiddles = precalc_twiddles(n);
	fft_compute_req(in, out, n, 1, twiddles);
	free(twiddles);
}
