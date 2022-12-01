#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//This program calculates coapex score for 1 fraction. ie. it takes an input matrix - and calculates coapex score for all possible pairs in that fraction.
//In a fraction, 2 proteins have a coapex score if they share modal abundance in the same exact fraction.
//2 types of co-apex scores are calculated, in case there are multiple fractions with modal abundance:
//1. If any of the fractions with modal abundance are matched in the two proteins, coapex score of 1, else 0
//2. A fraction of how many of the fractions with modal abundance are matched in the two proteins - for eg. if 2 fractions in protein A have modal abundance and 3 fractions in protein B have modal abundance, and only 2 match, coapex score would be 2(2)/2+3

//Usage:./coapex_score_one_fraction raw_data/human_beadA.tab > human_beadA_coapex.csv
//Input: A tab-separated matrix with first column as the protein code and the rest of the columns having spectral counts. Columns are number of fractions, rows are number of proteins 
//Output: A tab-separated file with following columns.
//Column1 - protein pair codes (Code1@Code2) where Code1 < Code2 on alphabetical sort
//Column2 - Coapex score type1
//Column3 - Coapex score type2 (the higher of the two scores.. since the denominator can vary for protein1 vs. protein2)

void initialize(char a[]);
void parseline(char b[],FILE *f);

int main(int argc, char **argv)
{
  FILE *fp;
  char line[5000],tmp[50];
  char codes[5000][500];
  float fractions[5000][200];

  int num_prot=0,ct=0,ct1=0,ct2=0;
  int i=0,j=0,x=0,y=0,a=0,b=0;

  float modal_value1=0,modal_value2=0,one_modal_fractions[200],two_modal_fractions[200];
  float coapex_score1=0;
  float coapex_score2=0.0; 
  float one_common_fractions[200],two_common_fractions[200]; // number of common fractions containing atleast 1 peptide
  int cf_ct1=0,cf_ct2=0;
  int match_fractions=0,common_fractions=0;

  //Input matrix - eg. human_beadA.tab - tab separated  
  if((fp=fopen(argv[1],"r"))==NULL)
  {
         printf("Unable to open file %s\n",argv[1]);
         return 100;
  }

  //Reading contents of matrix into arrays
  //codes[][],fractions[][]

  //First line - header - ignore it
  parseline(line,fp);
	
	num_prot=0;
  parseline(line,fp);
  while(line[0]!='Z')
  {
	//printf("%s\n",line);
	for(i=0;line[i]!='\t';i++)
		codes[num_prot][i]=line[i];
		codes[num_prot][i]='\0';

	//printf("%d:%s\n",num_prot+1,codes[num_prot]);

		ct=0;
		j=0;
	for(i++;line[i]!='\0';i++)
	{
		if(line[i]=='\t')
		{
			tmp[j]='\0';
			fractions[num_prot][ct]=atof(tmp);
			//printf("%s:%d\n",tmp,fractions[num_prot][ct]);
			j=0;
			ct++;
		}
		else
		{
			tmp[j]=line[i];	
			j++;
		}

	}

	//Processing last column

        tmp[j]='\0';
        fractions[num_prot][ct]=atof(tmp);


	num_prot++;
	parseline(line,fp);
  }

  /*for(i=0;i<num_prot;i++)
  {
	printf("%s\t",codes[i]);

  	for(j=0;j<ct;j++)
	{
		printf("%d\t",fractions[i][j]);
	}
	//last column
	printf("%d\n",fractions[i][j]);
  }*/

	//Finding modal abundances
  for(i=0;i<num_prot-1;i++)
  {
	//Finding modal value
	modal_value1=0;
	cf_ct1=0;
	for(x=0;x<=ct;x++)
	{
		if(fractions[i][x]>0)
		{
			one_common_fractions[cf_ct1]=x;
			cf_ct1++;
		}

		if(fractions[i][x]>modal_value1)
			modal_value1=fractions[i][x];
	}

	//Finding fractions containing modal value (abundance)
	ct1=0;
	for(x=0;x<=ct;x++)
	{
		if(fractions[i][x]==modal_value1)
		{
			one_modal_fractions[ct1]=x;
			//printf("%.2f:%.2f\n",modal_value1,one_modal_fractions[ct1]);
			ct1++;
		}
	}

	for(j=i+1;j<num_prot;j++)
	{
	        modal_value2=0;
		cf_ct2=0;
	        for(y=0;y<=ct;y++)
        	{
	                if(fractions[j][y]>0)
       		        {
                        	two_common_fractions[cf_ct2]=y;
                        	cf_ct2++;
                	}

               		if(fractions[j][y]>modal_value2)
                       		modal_value2=fractions[j][y];
        	}

        	ct2=0;
        	for(y=0;y<=ct;y++)
        	{
                	if(fractions[j][y]==modal_value2)
                	{
                        	two_modal_fractions[ct2]=y;
				//printf("~%.2f:%.2f\n",modal_value2,two_modal_fractions[ct2]);
                        	ct2++;
                	}
        	}

		//Number of fractions with matching modal abundance

		match_fractions=0;

		for(a=0;a<ct1;a++)
		{
			for(b=0;b<ct2;b++)
			{
				if(one_modal_fractions[a]==two_modal_fractions[b])
				{
					//printf("%d:%d >>\n",one_modal_fractions[a],two_modal_fractions[b]);
					match_fractions++;	
				}
			}
		}

		//Number of common fractions having atleast 1 peptide

		common_fractions=0;
                for(a=0;a<cf_ct1;a++)
                {
                        for(b=0;b<cf_ct2;b++)
                        {
                                if(one_common_fractions[a]==two_common_fractions[b])
                                {
                                        //printf("%d:%d >>\n",one_modal_fractions[a],two_modal_fractions[b]);
                                        common_fractions++;
                                }
                        }
                }


		//Coapex Score 1
		if(match_fractions > 0)
			coapex_score1=1;
		else
			coapex_score1=0;

		//Coapex Score 2

		coapex_score2=(2*(float)match_fractions)/(ct1+ct2);

		//Coapex Score 3 - number of match_fractions

		printf("%s@%s\t%.2f\t%.3f\t%d\t%d\n",codes[i],codes[j],coapex_score1,coapex_score2,match_fractions,common_fractions);	
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

