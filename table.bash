#!/usr/bin/bash
#bash PROGRAMMES/programme_tableau.bash FICHIER_URLS FICHIER_HTML LANGUE

echo "<html>" > $2
echo "<head><title>URL $3</title><meta charset=\"UTF-8\" /></head>" >> $2
echo "<body bgColor='9370DB'>" >> $2
echo "<hr color='white' /><h1><center><FONT color=\"white\" face=\"Cambria\">URL $3</FONT></center></h1><hr color='white' />" >> $2
echo "<p></p><table border=\"1\" bordercolor=\"white\" align=\"center\" width=\"75%\">" >> $2
echo "<tr>
		<th width=\"10%\"><FONT color=\"white\" face='Century Gothic'>N°</FONT></th>
		<th  width=\"90%\"><FONT color=\"white\" face='Century Gothic'>URL</FONT></th>
	</tr>" >> $2
count=1
		
for ligne in $(cat $1)
	do
	echo "<tr align=\"center\">
			<td><FONT color=\"white\">$count</FONT></td>
			<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
			onmouseout=\"this.style.backgroundColor='9370DB';\">
				<a target='_blank' href='$ligne' style='text-decoration: none'>
				<FONT color=\"white\">$ligne</FONT>
				</a></td>
			</tr>" >> $2
	count=$((count+1)) 
	done
	
echo "</table>" >> $2
echo "</body>" >> $2
echo "</html>" >> $2