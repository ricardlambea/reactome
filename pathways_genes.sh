
##################################

#	This script contains the commands used to create all the files that store the gene sets 
#	of the child pathways that relate directly to the parent pathway, whose ID is specified on the 
#	file name.
#	The parent pathway name can be found if the ID on the file name is looked up in the file
#	Reactome_TopLevel_Pathways.tsv.	


for id in $(gawk '{ if(NR>1){ gsub(/\.[[:digit:]]+/, "", $1); print $1 }}' Reactome_TopLevel_Pathways.tsv); 
	do child_ids=$(grep -E "$id" ReactomePathwaysRelation.txt | cut -f2); 
		for c_id in $child_ids; 
			do grep -E $c_id ReactomePathways.gmt >> gene_set_${id}; 
				echo "Finished one child ID"; 
			done; 
		echo "Finished one Parent ID"; 
	done


# In case we wanted to add at the beginning of each gene_set_* file a header with the tuple (pathway_id, pathway_name) 
# we just have to run the following

# Adding a -i flag to the last sed parameter to modify the files in-place

for i in $(ls gene_set_* | gawk '{gsub(/gene_set_/, "", $1); print}'); do line=$(grep -E $i Reactome_TopLevel_Pathways.tsv); header=$(echo $line | sed 's/ /\t/'); sed "1s/^/$header\n/" gene_set_${i}; done
