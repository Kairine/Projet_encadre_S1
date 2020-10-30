#!/usr/bin/bash
#bash PROGRAMMES/programme_tableau.bash DOSSIER_URLS FICHIER_HTML MOTIF

echo "<html>" > $2
echo "<head><title>TABLEAUX</title><meta charset=\"UTF-8\" /></head>" >> $2
echo "<body>" >> $2

comtab=1
for fichier in $(ls $1)
	do
	echo '' > corpus-$comtab.txt
	echo '' > corpus_ctx-$comtab.txt
	compteur=1
	echo "<table border=\"1\">" >> $2
	echo "<tr>
			<th>N° du lien</th>
			<th>Code Http</th>
			<th>URL</th>
			<th>Page aspirée</th>
			<th>Dump text</th>
			<th>Encodage</th>
			<th>Contexte</th>
			<th>Context HTML</th>
			<th>Fq Motif</th>
			<th>Index</th>
			<th>Bigramme</th>
			<th>Trigramme</th>
		</tr>" >> $2
	
	for ligne in $(cat $1/$fichier)
		do
		code_sortie=$(curl -sIL $ligne | head -n1 | cut -d" " -f2) 
		
function UTF8(){
lynx --assume-charset="UTF-8" --display-charset="UTF-8" -dump -nolist $ligne > ./DUMP-TEXT/$comtab-$compteur.txt
egrep -i "$3" ./DUMP-TEXT/$comtab-$compteur.txt > ./CONTEXTES/$comtab-$compteur.txt
echo -e "<fichier: $comtab-$compteur.txt>\n" >> corpus-$comtab.txt
cat ./DUMP-TEXT/$comtab-$compteur.txt >> corpus-$comtab.txt
echo -e "\n</fichier>\n" >> corpus-$comtab.txt
echo -e "<fichier: $comtab-$compteur.txt>\n" >> corpus_ctx-$comtab.txt
cat ./CONTEXTES/$comtab-$compteur.txt >> corpus_ctx-$comtab.txt
echo -e "\n</fichier>\n" >> corpus_ctx-$comtab.txt
nbmotif=$(egrep -coi "$3" ./DUMP-TEXT/$comtab-$compteur.txt)
perl5.28.0.exe ./minigrep/minigrepmultilingue.pl "utf-8" ./DUMP-TEXT/$comtab-$compteur.txt ./minigrep/motif-regexp.txt
mv resultat-extraction.html ./CONTEXTES/$comtab-$compteur.html
egrep -o "\w+" ./DUMP-TEXT/$comtab-$compteur.txt | sort | uniq -c | sort -r > ./DUMP-TEXT/$comtab-$compteur-index.txt
egrep -o "\w+" ./DUMP-TEXT/$comtab-$compteur.txt > bi1.txt
tail -n +2 bi1.txt > bi2.txt
tail -n +2 bi2.txt > bi3.txt
paste bi1.txt bi2.txt > big.txt
paste big.txt bi3.txt > tri.txt
cat big.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$comtab-$compteur-bigramme.txt
cat tri.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$comtab-$compteur-trigramme.txt
echo "<tr>
		<td>$comtab-$compteur</td>
		<td>$code_sortie</td>
		<td><a target='_blank' href='$ligne'>$ligne</a></td>
		<td><a target='_blank' href='../PAGES-ASPIREES/$comtab-$compteur.html'>Page aspirée n° $comtab-$compteur</a></td>
		<td><a target='_blank' href='../DUMP-TEXT/$comtab-$compteur.txt'>Dump text n°$comtab-$compteur</a></td>
		<td>$1</td>
		<td><a href=\"../CONTEXTES/$comtab-$compteur.txt\">Contexte $comtab-$compteur</a></td>
		<td><a href=\"../CONTEXTES/$comtab-$compteur.html\">Ctx HTML $comtab-$compteur</a></td>
		<td>$nbmotif</td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-index.txt\">Index $comtab-$compteur</a></td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-bigramme.txt\">Bigramme $comtab-$compteur</a></td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-trigramme.txt\">Trigramme $comtab-$compteur</a></td>
	</tr>" >> $2
}

function UTF8conv(){
lynx --assume-charset="UTF-8" --display-charset="UTF-8" -dump -nolist $ligne > ./DUMP-TEXT/$comtab-$compteur-$1.txt
iconv -s -f "$1" -t "UTF-8" ./DUMP-TEXT/$comtab-$compteur-$1.txt > ./DUMP-TEXT/$comtab-$compteur.txt
echo -e "<fichier: $comtab-$compteur.txt>\n" >> corpus-$comtab.txt
cat ./DUMP-TEXT/$comtab-$compteur.txt >> corpus-$comtab.txt
echo -e "\n</fichier>\n" >> corpus-$comtab.txt
egrep -i "$3" ./DUMP-TEXT/$comtab-$compteur.txt > ./CONTEXTES/$comtab-$compteur.txt
echo -e "<fichier: $comtab-$compteur.txt>\n" >> corpus_ctx-$comtab.txt
cat ./CONTEXTES/$comtab-$compteur.txt >> corpus_ctx-$comtab.txt
echo -e "\n</fichier>\n" >> corpus_ctx-$comtab.txt
nbmotif=$(egrep -coi "$3" ./DUMP-TEXT/$comtab-$compteur.txt)
perl5.28.0.exe ./minigrep/minigrepmultilingue.pl "utf-8" ./DUMP-TEXT/$comtab-$compteur.txt ./minigrep/motif-regexp.txt
mv resultat-extraction.html ./CONTEXTES/$comtab-$compteur.html
egrep -o "\w+" ./DUMP-TEXT/$comtab-$compteur.txt | sort | uniq -c | sort -r > ./DUMP-TEXT/$comtab-$compteur-index.txt
egrep -o "\w+" ./DUMP-TEXT/$comtab-$compteur.txt > bi1.txt
tail -n +2 bi1.txt > bi2.txt
tail -n +2 bi2.txt > bi3.txt
paste bi1.txt bi2.txt > big.txt 
paste big.txt bi3.txt > tri.txt
cat big.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$comtab-$compteur-bigramme.txt
cat tri.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$comtab-$compteur-trigramme.txt
echo "<tr>
		<td>$comtab-$compteur</td>
		<td>$code_sortie</td>
		<td><a target='_blank' href='$ligne'>$ligne</a></td>
		<td><a target='_blank' href='../PAGES-ASPIREES/$comtab-$compteur.html'>Page aspirée n° $comtab-$compteur</a></td>
		<td><a target='_blank' href='../DUMP-TEXT/$comtab-$compteur.txt'>Dump text n°$comtab-$compteur</a></td>
		<td>$1</td>
		<td><a href=\"../CONTEXTES/$comtab-$compteur.txt\">Contexte $comtab-$compteur</a></td>
		<td><a href=\"../CONTEXTES/$comtab-$compteur.html\">Ctx HTML $comtab-$compteur</a></td>
		<td>$nbmotif</td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-index.txt\">Index $comtab-$compteur</a></td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-bigramme.txt\">Bigramme $comtab-$compteur</a></td>
		<td><a href=\"../DUMP-TEXT/$comtab-$compteur-trigramme.txt\">Trigramme $comtab-$compteur</a></td>
	</tr>" >> $2
}

function Pbenc(){
echo -e "PB Encodage...$comtab::$compteur::$code_sortie::$1::$ligne\n"
echo "<tr>
		<td>$comtab-$compteur</td>
		<td>$code_sortie</td>
		<td><a target='_blank' href='$ligne'>$ligne</a></td>
		<td><a target='_blank' href='../PAGES-ASPIREES/$comtab-$compteur.html'>Page aspirée n° $comtab-$compteur</a></td>
		<td>-</td>
		<td>$1</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	</tr>" >> $2
}

function Pburl(){
echo -e "PB URL...$comtab::$compteur::$code_sortie::::$ligne\n"
echo "<tr>
		<td>$comtab-$compteur</td>
		<td>$code_sortie</td>
		<td><a target='_blank' href='$ligne'>$ligne</a></td>
		<td><a target='_blank' href='../PAGES-ASPIREES/$comtab-$compteur.html'>Page aspirée n° $comtab-$compteur</a></td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	</tr>" >> $1
}
		
		if [[ $code_sortie == 200 ]]
		then
			curl -sL -o ./PAGES-ASPIREES/$comtab-$compteur.html $ligne
			#on essaie sans file
			encodage=$(egrep -oi "charset=[\"a-zA-Z0-9-]*" ./PAGES-ASPIREES/$comtab-$compteur.html | head -1 | cut -d"=" -f2 | egrep -oi "[a-zA-Z0-9-]*" | tr "[a-z]" "[A-Z]")
			echo "ligne$comtab-$compteur encodage: $encodage"
			if [[ $encodage == "UTF-8" ]]
			then 
				UTF8 $encodage $2 $3
			else
				reponse=$(iconv -l | egrep "$encodage")
				if [[ $reponse != "" ]]
				then
					UTF8conv $encodage $2 $3
				else
					Pbenc $encodage $2
				fi
			fi
		else
		Pburl $2
		fi
		compteur=$((compteur+1)) 
		done
	echo "</table>" >> $2
	egrep -o "\w+" ./corpus-$comtab.txt | sort | uniq -c | sort -r > corpus-$comtab-index.txt
	egrep -o "\w+" ./corpus_ctx-$comtab.txt | sort | uniq -c | sort -r > corpus_ctx-$comtab-index.txt
	echo "<tr>
			<td align = "center" width=\"25%\"><a target='_blank' href='./corpus-$comtab.html'>Corpus N° $comtab</a></td>
			<td align = "center" width=\"25%\"><a target='_blank' href='./corpus_ctx-$comtab.html'>Contexte N° $comtab</a></td>
			<td align = "center" width=\"25%\"><a target='_blank' href='./corpus-$comtab-index.html'>Corpus index N° $comtab</a></td>
			<td align = "center" width=\"25%\"><a target='_blank' href='./corpus_ctx-$comtab-index.html'>Contexte index N° $comtab</a></td>
		</tr>" >> $2
	echo "<hr color='blue' />" >> $2
	comtab=$((comtab + 1))
	done
	

echo "</body>" >> $2
echo "</html>" >> $2