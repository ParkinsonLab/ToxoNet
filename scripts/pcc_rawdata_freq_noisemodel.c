#Author: Swapna Seshadri

# include<stdio.h>
# include<string.h>
# include<stdlib.h>
# include<math.h>
# include <gsl/gsl_rng.h>
# include <gsl/gsl_randist.h>

#Usage:
//Eg: ./pcc_rawdata_freq_noisemodel  matrix_curated_g2e2ma > pcc_rawdata_freq_noisemodel.csv

#Notes:
#Because it uses gsl libraries, needs to be compiled as shown below.

###

## For cases when it says it cant find libgsl.so.0: cannot open shared object file - try this
## LD_LIBRARY_PATH=/home/swapna/workspace/software/gsl-1.9/.libs/
## export LD_LIBRARY_PATH
## Then, run your program

void initialize(char a[]);
void parseline(char b[],FILE *f);

int main(int argc, char **argv)
{
  FILE *fp1,*fp2;

  float data1[1000],data2[1000],data1p[1000],data2p[1000],pcc_poisson[1000];
  
  float d1mean=0.0,d1single=0.0,d1square=0.0,pcc_mean=0.0;
  float d2mean=0.0,d2single=0.0,d2square=0.0;
  
  float numerator=0.0,denominator=0.0,d1denom=0.0,d2denom=0.0;
  float cor_cofft=0.0;

  float genes_totpep_data1=0.0, genes_totpep_data2=0.0;

  int i=0,j=0,p=0,q=0,z=0,ct=0,columns=0,x=0;

  char line1[50000],line2[50000],line3[50000],tmpval[30],outfile[500],tmpstr[500],codes[100000][500];

  const gsl_rng_type * T;
  gsl_rng * r;


  if((fp1=fopen(argv[1],"r"))==NULL)
  {
         printf("Unable to open file %s\n",argv[1]);
         return 100;
  }

  if((fp2=fopen(argv[1],"r"))==NULL)
  {
         printf("Unable to open file %s\n",argv[1]);
         return 100;
  }


//Extracting details from file 1

  //printf("Here\n");
  parseline(line1,fp1);

  //Skip first line as it contains headers

  parseline(line1,fp1);	//2nd line onwards

  //Getting all the gene codes
 
	ct=0; 
  while(line1[0]!='Z')
  {
	//printf("%s\n",line1);
	for(i=0;line1[i]!='\t';i++)
	{
		tmpstr[i]=line1[i];
	}
		tmpstr[i]='\0';
		//printf("%s\n",tmpstr);
		strcpy(codes[ct],tmpstr);	

	parseline(line1,fp1);
	ct++;
  }


  /* create a generator chosen by the
     environment variable GSL_RNG_TYPE */

  gsl_rng_env_setup();

  T = gsl_rng_default;
  r = gsl_rng_alloc (T);


 
 //Calculating pearson correl coefft for pairwise combinations of genes

 rewind(fp1);
 parseline(line1,fp1); // skip first line - the header
 parseline(line1,fp1);

 //printf("%f\n",(float)1/320);
 p=0; q=0;

 while(line1[0]!='Z')
 {
	//printf("%s\n",line1);
	//Extract data for the current line

        //Skip 1st column as it contains only amino acid details
	for(i=0;line1[i]!='\t';i++);

                z=0;
		genes_totpep_data1=0.0;
        for(i++;line1[i]!='\0';i++)
        {
                initialize(tmpval);

                for(j=0;line1[i]!='\t' &&  line1[i]!='\0';i++,j++)
                        tmpval[j]=line1[i];

                tmpval[j]='\0';


                data1[z]=atof(tmpval);
		genes_totpep_data1=genes_totpep_data1+data1[z];
		//printf("%s,%f ",tmpval,data1[z]);
                z++;
        }
	//printf("\n");

	columns=z;

	



	//Extract data for other lines in the file
	rewind(fp2);
	parseline(line2,fp2);
	parseline(line2,fp2);


	while(line2[0]!='Z')
	{

		if(p<q)
		{
			//printf("%s,%f ======== %s,%f\n",codes[p],genes_totpep[p],codes[q],genes_totpep[q]);

			//printf("%s\n",line2);
		        for(i=0;line2[i]!='\t';i++);
                		z=0;
				genes_totpep_data2=0.0;
		        for(i++;line2[i]!='\0';i++)
		        {
               			initialize(tmpval);

		                for(j=0;line2[i]!='\t' && line1[i]!='\0';i++,j++)
		                        tmpval[j]=line2[i];
               			tmpval[j]='\0';

                		data2[z]=atof(tmpval);
				genes_totpep_data2=genes_totpep_data2+data2[z];

				//printf("%s,%f ",tmpval,data2[z]);
		                z++;
			}

			  /* print n random variates chosen from
			     the poisson distribution with mean
			     parameter mu */

			for (x = 0; x < 1000; x++)
			{

				for(z=0;z<columns; z++)
				{
					data1p[z]=data1[z]+(1.0/columns);
					//printf("%d --> %f - %f,",x,data1[z],data1p[z]);
					data1p[z]=gsl_ran_poisson(r,data1p[z]);
					//printf("%f|",data1p[z]);
				
					data2p[z]=data2[z]+(1.0/columns);
					//printf("%f - %f,",data2[z],data2p[z]);
					data2p[z]=gsl_ran_poisson(r,data2p[z]);
					//printf("%f|",data2p[z]);

					data1p[z]=(float)data1p[z]/genes_totpep_data1;
					data2p[z]=(float)data2p[z]/genes_totpep_data2;
	
					//printf("%f,%f~%f,%f~%d\n",data1p[z],data2p[z],genes_totpep_data1,genes_totpep_data2,columns);

				}
		
					d1mean=0.0;
				for(i=0;i<columns;i++)
					d1mean=d1mean+data1p[i];
				//printf("====== %f ",d1mean);
				d1mean=d1mean/columns;
				//printf("%f |",d1mean); 
	
					d2mean=0.0;
				for(i=0;i<columns;i++)
					d2mean=d2mean+data2p[i];
				//printf(" %f ",d2mean);
				d2mean=d2mean/columns;
				//printf(" %f\n",d2mean);

				numerator=0.0;
				d1denom=0.0;
				d2denom=0.0;
				denominator=0.0;

				for(i=0;i<columns;i++)
				{
					d1single=data1p[i]-d1mean;
					d1square=d1single*d1single;
					d2single=data2p[i]-d2mean;
					d2square=d2single*d2single;

					numerator=numerator+d1single*d2single;	
		
					d1denom=d1denom+d1square;
					d2denom=d2denom+d2square;

					//printf("%f-%f,%f-%f\n",data1p[i],d1mean,data2p[i],d2mean);
				}

	
				denominator=sqrt(d1denom)*sqrt(d2denom);

				cor_cofft=numerator/denominator;
				pcc_poisson[x]=cor_cofft;

				//printf("%s-%s,%d-%d:%f\n",codes[p],codes[q],p,q,cor_cofft);


			}

					pcc_mean=0.0;
				for(x=0;x<1000;x++)
					pcc_mean=pcc_mean+pcc_poisson[x];
				pcc_mean=pcc_mean/1000;

				printf("%s#%s#%f\n",codes[p],codes[q],pcc_mean);

		}
		parseline(line2,fp2);	
		q++;	
	}
	parseline(line1,fp1);
	p++;
	q=0;
  
  //gsl_rng_free (r);
				

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

