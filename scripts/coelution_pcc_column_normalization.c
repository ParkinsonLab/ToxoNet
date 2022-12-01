//Author: Swapna Seshadri

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
  FILE *fp1;

  char line1[50000],codes[5000][500];

  char tmpstr[500],tmpval[100];

  int i=0,j=0,m=0,n=0,p=0,q=0,x=0,columns=0,rows=0;

  int nr=2000,nc=500;

  float pcc_poisson[1000];
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


  if((fp1=fopen(argv[1],"r"))==NULL)
  {
         printf("Unable to open file %s\n",argv[1]);
         return 100;
  }


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

 	//Getting the counts into a MxN matrix


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

	/*printf("Rows and columns\n");

	for(m=0;m<rows;m++)
	{
		for(n=0;n<columns;n++)
		{
			printf("%.f,",matrix[m][n]);
		}
		printf("\n");
	}*/
	
	//Getting column totals - ie. total number of peptides per fraction 
	for(n=0;n<columns;n++)
  	{
		column_totals[n]=0;
        	for(m=0;m<rows;m++)
        	{
			column_totals[n]=column_totals[n]+matrix[m][n];
			//printf("%.0f,",nmatrix[m][n]);

        	}
		//printf("\n");
  	}

	for(n=0;n<columns;n++)
	{
		printf("%.f\n",column_totals[n]);
	}

      	//Getting row totals - ie. total number of peptides per protein
        for(m=0;m<rows;m++)
        {
		row_totals[m]=0;
		for(n=0;n<columns;n++)
		{
			 row_totals[m]=row_totals[m]+matrix[m][n];
		}
	}

        /*printf("Now\n");
        for(m=0;m<rows;m++)
        {
                printf("%s,%.f\n",codes[m],row_totals[m]);
        }*/
 

	  /* create a generator chosen by the
     environment variable GSL_RNG_TYPE */

	  gsl_rng_env_setup();

	  T = gsl_rng_default;
	  r = gsl_rng_alloc (T);

	  //printf("%d,%d\n",rows,columns); 
	
          for(p=0;p<rows-1;p++)   //First coelution profile
          {
                for(q=p+1;q<rows;q++)   //Second coelution profile
                {
			        p_mean=0.0;
	                        q_mean=0.0;

				//Setting temporary matrix to 0
				for(i=0;i<2000;i++)
				{
					for(j=0;j<500;j++)
					{
						tmp_matrix[i][j]=0.0;
					}
				}

                                for(n=0;n<columns;n++)
                                {

					//tmp_matrix[p][n]=matrix[p][n]+(1.0/columns);
					//tmp_matrix[p][n]=gsl_ran_poisson(r,matrix[p][n]);
					tmp_matrix[p][n]=matrix[p][n]/column_totals[n];
					//tmp_matrix[p][n]=(float)matrix[p][n]/row_totals[p];
					//tmp_matrix[p][n]=matrix[p][n];


					//tmp_matrix[q][n]=matrix[q][n]+(1.0/columns);
					//tmp_matrix[q][n]=gsl_ran_poisson(r,matrix[q][n]);
					tmp_matrix[q][n]=matrix[q][n]/column_totals[n];
					//tmp_matrix[q][n]=(float)matrix[q][n]/row_totals[q];
					//tmp_matrix[q][n]=matrix[q][n];


                                        p_mean=p_mean+tmp_matrix[p][n];
                                        q_mean=q_mean+tmp_matrix[q][n];

					printf("%d: %.2f,%.2f\n",n,p_mean,q_mean);

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

				pcc_mean=numerator/denominator;

                                printf("%s\t%s\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",codes[p],codes[q],columns,p_mean,q_mean,p_denom,q_denom,numerator,denominator,pcc_mean);
                                printf("%s\t%s\t%.3f\n",codes[p],codes[q],pcc_mean);

		}

	  }


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

