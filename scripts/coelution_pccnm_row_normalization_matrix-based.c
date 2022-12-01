//Author: Swapna Seshadri

//This code implements a version of the Pearson Correlation Coefficient Score in the Havugimana et.al. paper. (PCC with noise modelling) - this differs from the method described in the paper in that it involves "row normalization" of spectral counts, rather than the "column normalization" 

# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <math.h>
# include <gsl/gsl_rng.h>
# include <gsl/gsl_randist.h>

//Usage:
//Eg: ./pcc_rawdata_freq_noisemodel  matrix_curated_g2e2ma > pcc_rawdata_freq_noisemodel.csv

/*Notes:
Option 1:
Install gsl (I used gsl-1.9 in /home/swapna/workspace/software/gsl-1.9/) and do make install with sudo - so that it is available across sets
And compile as follows
gcc -o test_pccnm test_pccnm.c -lgsl -lgslcblas -lm

Use this for faster optimisation
gcc -o coelution_pccnm_row_normalization_test coelution_pccnm_row_normalization_test.c -lgsl -lgslcblas -lm -Ofast -march=native

Other options (??)
Because it uses gsl libraries, needs to be compiled as shown below.

cc -Wall -I/home/swapna/workspace/software/gsl-1.9/ -o pcc_rawdata_freq_noisemodel_column-based pcc_rawdata_freq_noisemodel_column-based.c -lm

For cases when it says it cant find libgsl.so.0: cannot open shared object file - try this
LD_LIBRARY_PATH=/home/swapna/workspace/software/gsl-1.9/.libs/
export LD_LIBRARY_PATH
Then, run your program */

void initialize(char a[]);
void parseline(char b[],FILE *f);

//int main(int argc, char **argv)
int main(int argc, char *argv[])
{
  FILE *fp1,*fw;

  char line1[50000],codes[5000][500];

  char tmpstr[500],tmpval[100];

  int i=0,j=0,m=0,n=0,p=0,q=0,x=0,columns=0,rows=0;

  int nr=2000,nc=500;

  float pcc=0.0;
  float column_totals[500],row_totals[5000];

  float p_mean=0.0,q_mean=0.0,p_denom=0.0,q_denom=0.0,numerator=0.0,denominator=0.0,p_single=0.0,q_single=0.0,p_square=0.0,q_square=0.0,pcc_mean=0.0; 

  const gsl_rng_type * T;
  gsl_rng * r;

  
  float **matrix=(float **)malloc(nr * sizeof(float *));
  for(i=0;i<nr;i++)
        matrix[i]=(float *)malloc(nc * sizeof(float));

  float **tmp_matrix=(float **)malloc(nr * sizeof(float *));
  for(i=0;i<nr;i++)
	tmp_matrix[i]=(float *)malloc(nc * sizeof(float));

  //This matrix scores the pearson correlation coefficients for all-vs-all protein codes
  float **pcc_matrix=(float **)malloc(nr * sizeof(float *));
  for(i=0;i<nr;i++)
        pcc_matrix[i]=(float *)malloc(nr * sizeof(float));



  if((fp1=fopen(argv[1],"r"))==NULL)
  {
         printf("Unable to open file %s\n",argv[1]);
         return 100;
  }

  if((fw=fopen(argv[2],"w"))==NULL)
  {
         printf("Unable to open file %s\n",argv[2]);
         return 100;
  }

  printf("SOMETHING IS WRONG WITH THIS - DO NOT USE IT\n");
  exit(0);

  //Initializing variables

  initialize(line1);
  initialize(tmpstr);
  initialize(tmpval);

  for(i=0;i<5000;i++)
  {
	initialize(codes[i]);
  }

  for(i=0;i<2000;i++)
  {
	for(j=0;j<500;j++)
	{
		matrix[i][j]=0.0;
		tmp_matrix[i][j]=0.0;
	}
  }

  for(i=0;i<2000;i++)
  {
        for(j=0;j<2000;j++)
        {
                pcc_matrix[i][j]=0.0;
        }
  }


  for(j=0;j<500;j++)
  {
	column_totals[j]=0;
  }

//Extracting details from file 1 - number of rows, columns, protein codes, MxN matrix of peptide counts

  	//printf("Here\n");
	//Skip first line as it contains headers 
	parseline(line1,fp1);

  	//Start from 2nd line onwards
	parseline(line1,fp1);

	//Getting all the protein codes from column1
        	rows=0;
	while(line1[0]!='Z')
  	{
        	//printf("%s\n",line1);
		initialize(tmpstr);
        	for(i=0;line1[i]!='\t';i++)
                	tmpstr[i]=line1[i];
                	tmpstr[i]='\0';
                //printf("%s\n",tmpstr);
                strcpy(codes[rows],tmpstr);
		//printf("%s\n",codes[rows]);

 	       parseline(line1,fp1);
       	       rows++;
  	}

 	//Getting the counts into a MxN matrix	- Matrix 'A' in the paper


	rewind(fp1);
	parseline(line1,fp1); // skip first line - the header
	parseline(line1,fp1);

        m=0;
	while(line1[0]!='Z')
  	{
        	//Skip 1st column as it contains only codes 
	        for(i=0;line1[i]!='\t';i++);

       		n=0;
	        for(i++;line1[i]!='\0';i++)
       		{
                	initialize(tmpval);

	                for(j=0;line1[i]!='\t' &&  line1[i]!='\0';i++,j++)
       	                	tmpval[j]=line1[i];

	                tmpval[j]='\0';

       		        matrix[m][n]=atof(tmpval);
	                //printf("%.0f,",matrix[m][n]);
        	        n++;
        	}

		//printf("%d\n",n);

	        parseline(line1,fp1);
       		m++;
  	}

	columns=n;
	//printf("%d,%d\n",rows,columns);

	//printf("Rows and columns\n");

	/*for(n=0;n<columns;n++)
	{
		column_totals[n]=0;
		for(m=0;m<rows;m++)
		{
			column_totals[n]=column_totals[n]+matrix[m][n];
		}
	}*/

        for(m=0;m<rows;m++)
        {
	        row_totals[m]=0;
                for(n=0;n<columns;n++)
                {
       	        	row_totals[m]=row_totals[m]+matrix[m][n];
                }
        }


	/*printf("Orig\n");
	for(n=0;n<columns;n++)
	{
		printf("%d: %.0f\n",n,column_totals[n]);
	}*/

	//noise term added to the maximum likelihood estimate of each fraction in matrix A -> getting matrix C in the paper
	for(m=0;m<rows;m++)
	{
		for(n=0;n<columns;n++)
		{
			//printf("%.f,",matrix[m][n]);
			matrix[m][n]=matrix[m][n]+(1.0/columns);
	
		}
		//printf("\n");
	}

        //Rerunning the mass-spec experiment in-silico by drawing randomly from Poisson C(i,j) for each cell, then normalizing using row-normalization, and calculating pearson correlation coefficient - which is repeated a 1000 times 

         /* create a generator chosen by the
            environment variable GSL_RNG_TYPE */
                gsl_rng_env_setup();

                T = gsl_rng_default;
                r = gsl_rng_alloc (T);


	for(x=0;x<1000;x++)
	{

        	//Modelling the peptide count in each fraction as a poisson process

		for(m=0;m<rows;m++)
        	{
                	for(n=0;n<columns;n++)
                	{
				tmp_matrix[m][n]=gsl_ran_poisson(r,matrix[m][n]);
			}
		}
	
		//Getting column totals - ie. total number of peptides per fraction 
		/*for(n=0;n<columns;n++)
  		{
			column_totals[n]=0;
	        	for(m=0;m<rows;m++)
       	 		{
				column_totals[n]=column_totals[n]+tmp_matrix[m][n];
				//printf("%.0f,",matrix[m][n]);
        		}
			//printf("\n");
  		}*/

		/*printf("%d >>>\n",x);
		for(n=0;n<columns;n++)
		{
			printf("%.f\n",column_totals[n]);
		}*/

	      	//Getting row totals - ie. total number of peptides per protein
       	 	/*for(m=0;m<rows;m++)
        	{
			row_totals[m]=0;
			for(n=0;n<columns;n++)
			{
				 row_totals[m]=row_totals[m]+tmp_matrix[m][n];
			}
		}*/

	  	//printf("%d,%d\n",rows,columns); 

		//Calculating pearson correlation coefficient for all-vs-all pairs after normalizing peptides to frequencies	
	        for(p=0;p<rows-1;p++)   //First protein's coelution profile
          	{
                	for(q=p+1;q<rows;q++)   //Second protein's coelution profile
                	{
                                p_mean=0.0;
                                q_mean=0.0;

                                for(n=0;n<columns;n++)
                                {
					tmp_matrix[p][n]=(float)tmp_matrix[p][n]/row_totals[p];
					tmp_matrix[q][n]=(float)tmp_matrix[q][n]/row_totals[q];

                                        p_mean=p_mean+tmp_matrix[p][n];
                                        q_mean=q_mean+tmp_matrix[q][n];
                                }

                                p_mean=p_mean/columns;
                                q_mean=q_mean/columns;

                                //Calculating pearson correlation coefficient between the two normalized profiles (Wikepedia equation)

                                numerator=0.0;
                                p_denom=0.0;
                                q_denom=0.0;
                                denominator=0.0;

                                for(n=0;n<columns;n++)
                                {
                                        p_single=tmp_matrix[p][n]-p_mean;
                                        p_square=p_single*p_single;

                                        q_single=tmp_matrix[q][n]-q_mean;
                                        q_square=q_single*q_single;

                                        numerator=numerator+(p_single*q_single);

                                        p_denom=p_denom+p_square;
                                        q_denom=q_denom+q_square;
                                }

                                denominator=sqrt(p_denom)*sqrt(q_denom);

				pcc=numerator/denominator;
				pcc_matrix[p][q]=pcc_matrix[p][q]+pcc;

				//printf("%d: %s\t%s\t%.2f\n",x,codes[p],codes[q],pcc);
			}
		}


	}

	//Getting average pcc for 1000 runs by averaging

        for(p=0;p<rows-1;p++)
	{
		for(q=p+1;q<rows;q++)
		{
			pcc_matrix[p][q]=pcc_matrix[p][q]/1000;
		}
	}

	//Output pcc for all-vs-all pairs (minus the same protein codes)
	for(p=0;p<rows-1;p++)
	{
		for(q=p+1;q<rows;q++)
		{
		        //printf("%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",codes[p],codes[q],p_mean,q_mean,p_denom,q_denom,numerator,denominator,pcc_mean);
         		fprintf(fw,"%s\t%s\t%.3f\n",codes[p],codes[q],pcc_matrix[p][q]);
		}
	}


		gsl_rng_free (r);

  return 0;
}

                                                                                                                             
void initialize(char a[])
{
  int i;
  //for( i = 0; i < 300; i++ )
  for( i = 0; a[i] != '\0'; i++ )
        *(a+i) = '\0';
}
                                                                                                                             
void parseline(char b[],FILE *f)
{
   int i=0;
   char c;
                                                                                                                             
     initialize(b);
     c=fgetc(f);
     while(c!=EOF && c!='\n')
     {
                                                                                                                             
           b[i]=c;
            i++;
           c=fgetc(f);
     }
                                                                                                                             
    b[i]='\0';
    if(c==EOF)
       b[0]='Z';
}

