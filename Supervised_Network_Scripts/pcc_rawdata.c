# include<stdio.h>
# include<string.h>
# include<stdlib.h>
# include<math.h>

//correl_coefft <file1.mat> or <file1.tab> - a tab separated matrix of M rows (no. of genes) and N columns (ie. conditions)
//First row - is a header consisting of all gene conditions 
//Eg: ./pcc_rawdata matrix_curated_g2e2ma > pcc_rawdata.csv

void initialize(char a[]);
void parseline(char b[],FILE *f);

int main(int argc, char **argv)
{
  FILE *fp1,*fp2;

  float data1[10000],data2[10000];

  float d1mean=0.0,d1single=0.0,d1square=0.0;
  float d2mean=0.0,d2single=0.0,d2square=0.0;
  
  float numerator=0.0,denominator=0.0,d1denom=0.0,d2denom=0.0;
  float cor_cofft=0.0;

  int i=0,j=0,p=0,q=0,z=0,ct=0,columns=0;

  char line1[50000],line2[50000],tmpval[300],outfile[1000],tmpstr[1000],codes[10000][100];

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
		strcpy(codes[ct],tmpstr);	

	parseline(line1,fp1);
	ct++;
  }


 
 //Calculating pearson correl coefft for pairwise combinations of genes

 rewind(fp1);
 parseline(line1,fp1); // skip first line - the header
 parseline(line1,fp1);


 p=0; q=0;

 while(line1[0]!='Z')
 {
	//printf("%s\n",line1);
	//Extract data for the current line

        //Skip 1st column as it contains only amino acid details
	for(i=0;line1[i]!='\t';i++);

                z=0;
        for(i++;line1[i]!='\0';i++)
        {
                initialize(tmpval);

                for(j=0;line1[i]!='\t' &&  line1[i]!='\0';i++,j++)
                        tmpval[j]=line1[i];

                tmpval[j]='\0';


                data1[z]=atof(tmpval);
		//printf("%s,%f,%d ",tmpval,data1[z],z);
                z++;
        }
	//printf("\n");

	columns=z;
		d1mean=0.0;
	for(i=0;i<columns;i++)
	{
		//printf("%f\n",data1[i]);
		d1mean=d1mean+data1[i];
	}
	d1mean=d1mean/columns;
	//printf("=== %f\n",d1mean);


	//Extract data for other lines in the file
	rewind(fp2);
	parseline(line2,fp2);
	parseline(line2,fp2);


	while(line2[0]!='Z')
	{

		if(p<q)
		{	
			//printf("%s\n",line2);
		        for(i=0;line2[i]!='\t';i++);
                		z=0;
		        for(i++;line2[i]!='\0';i++)
		        {
               			initialize(tmpval);

		                for(j=0;line2[i]!='\t' && line1[i]!='\0';i++,j++)
		                        tmpval[j]=line2[i];
               			tmpval[j]='\0';

                		data2[z]=atof(tmpval);
		                z++;
			}

				d2mean=0.0;
			for(i=0;i<columns;i++)
			{
				//printf("%f\n",data2[i]);
				d2mean=d2mean+data2[i];
			}
			d2mean=d2mean/columns;
			//printf("=== %f\n",d2mean);

			numerator=0.0;
			d1denom=0.0;
			d2denom=0.0;
			denominator=0.0;

			for(i=0;i<columns;i++)
			{
				d1single=data1[i]-d1mean;
				d1square=d1single*d1single;
		
				d2single=data2[i]-d2mean;
				d2square=d2single*d2single;

				numerator=numerator+d1single*d2single;	
		
				d1denom=d1denom+d1square;
				d2denom=d2denom+d2square;
			}


			denominator=sqrt(d1denom)*sqrt(d2denom);

			cor_cofft=numerator/denominator;

			//printf("%s-%s,%d-%d:%.2f\n",codes[p],codes[q],p,q,cor_cofft);
			printf("%s#%s#%.3f\n",codes[p],codes[q],cor_cofft);

		}
		parseline(line2,fp2);	
		q++;	
	}
	parseline(line1,fp1);
	p++;
	q=0;
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

