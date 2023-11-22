#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include "alloc.h"

#define ZERO          0.0E+0

double L( double p0, double p, double w );

int main()
{
  FILE    *fl0, *fl1;
  int     i, j, N, NC=3;
  double  w, step, CRA, CIRI, cfreq;

  char    Infile0 [] = "input.cnv", Infile[256], aux[256];
  double  *Freq, *IRI, *RA;

  if ( ! (fl0=fopen(Infile0,"r")) )
    {
      printf("\nError: The file \"%s\" is not available!\n",Infile);
      exit(EXIT_FAILURE);
    }

  fscanf(fl0,"%d", &N);
  printf("# Number of points: %d", N);fflush(stdout);
  //
  Freq = Real_alloca(N);
  IRI = Real_alloca(N);
  RA = Real_alloca(N);
  //
  fscanf(fl0, "%lf", &w);
  printf("\n# Experimental broadening (FWHM): %lf", w);
  step = w/1.0E+2;
  
  //printf("Type the name of the file: %s");
  fscanf(fl0,"%s %d", &Infile, &NC);
  printf("\n# Input data file: %s", Infile);
  printf("\n# Number of columns in input data file: %d", NC);
  
  if ( ! (fl1=fopen(Infile,"r")) )
    {
      printf("\nError: The file \"%s\" is not available!\n",Infile);
      exit(EXIT_FAILURE);
    }

  printf("\n\n# Original bar spectra:\n# =======================");
  fgets(aux, 256, fl1);
  //printf("\n aux value= %s",aux);
  for ( i = 0; i < N; i++ ) {
    if ( NC == 3 ) {
      fscanf(fl1,"%lf %lf %lf", &Freq[i], &IRI[i], &RA[i]);
      printf("\n %12.6lf   %12.6lf   %12.6lf",Freq[i],ZERO,ZERO);
      printf("\n %12.6lf   %12.6lf   %12.6lf",Freq[i],IRI[i],RA[i]);
      printf("\n %12.6lf   %12.6lf   %12.6lf",Freq[i],ZERO,ZERO);
    }
    else if ( NC == 2 ) {
      fscanf(fl1,"%lf %lf ", &Freq[i], &IRI[i]);
      printf("\n %12.6lf   %12.6lf",Freq[i],ZERO);
      printf("\n %12.6lf   %12.6lf",Freq[i],IRI[i]);
      printf("\n %12.6lf   %12.6lf",Freq[i],ZERO);
    }
    else {
      printf(" NC value not found!");
    }
  }
  
  printf("\n\n#\tConvoluted spectra:\n#\t===================\n");
  i = 0;
  do {
    CIRI = 0.0E+0;
    CRA = 0.0E+0;
    cfreq = (i-1)*step + Freq[0];
    for ( j = 0; j < N; j++ ) {
      CIRI = CIRI + L(cfreq, Freq[j], w)*IRI[j];
      if ( NC == 3 ) CRA = CRA + L(cfreq, Freq[j], w)*RA[j];
    }
    if ( NC == 3 ) {
      printf("\t%12.6lf   %12.6lf   %12.6lf\n", cfreq, CIRI, CRA);
    }
    else if ( NC == 2 ) {
      printf("\t%12.6lf   %12.6lf\n", cfreq, CIRI);
    }
    i++;
  } while ( cfreq < (Freq[N-1] + w) );

  free(Freq);
  free(IRI);
  free(RA);
  //
  printf("\n # Done!\n");
  
  return 0;

}

double L( double p0, double p, double w )
{
  double x, L;
  x = 2*(p0 - p)/w;
  L = 1/(1 + x*x);
  return L;
}


