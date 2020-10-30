#!/usr/bin/bash
#bash PROGRAMMES/programme_tableau.bash FICHIER_URLS FICHIER_HTML MOTIF [FR|EN|CN]

echo "<html>" > $2
echo "<head><title>TABLEAU $4</title><meta charset=\"UTF-8\" /></head>" >> $2
echo "<body bgColor='9370DB'>" >> $2
echo "<hr color='white' /><h1><center><FONT color=\"white\" face=\"Cambria\">TABLEAUX $4</FONT></center></h1><hr color='white' />" >> $2


echo '' > corpus-$4.txt
echo '' > corpus_ctx-$4.txt
compteur=1
echo "<p></p><table border=\"1\" bordercolor=\"white\" align=\"center\" width=\"75%\">" >> $2
echo "<tr>
		<th><FONT color=\"white\" face='Century Gothic'>N°</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Code Http</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>URL</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Page aspirée</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Dump text</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Encodage</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Contexte</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Context HTML</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Fq Motif</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Index</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Bigramme</FONT></th>
		<th><FONT color=\"white\" face='Century Gothic'>Trigramme</FONT></th>
	</tr>" >> $2

for ligne in $(cat $1)
	do
	code_sortie=$(curl -sIL $ligne | head -n1 | cut -d" " -f2) 

	if [[ $code_sortie == 200 ]]
	then
		curl -sL -o ./PAGES-ASPIREES/$4-$compteur.html $ligne
		encodage=$(egrep -oi "charset=[\"a-zA-Z0-9-]*" ./PAGES-ASPIREES/$4-$compteur.html | head -1 | cut -d"=" -f2 | egrep -oi "[a-zA-Z0-9-]*" | tr "[a-z]" "[A-Z]")
		echo "ligne$4-$compteur encodage: $encodage"
		if [[ $encodage == "UTF-8" ]]
		then 
			lynx --assume-charset="UTF-8" --display-charset="UTF-8" -dump -nolist $ligne > ./DUMP-TEXT/$4-$compteur.txt
			egrep -i "$3" ./DUMP-TEXT/$4-$compteur.txt > ./CONTEXTES/$4-$compteur.txt
			echo -e "<fichier: $4-$compteur.txt>\n" >> corpus-$4.txt
			cat ./DUMP-TEXT/$4-$compteur.txt >> corpus-$4.txt
			echo -e "\n</fichier>\n" >> corpus-$4.txt
			echo -e "<fichier: $4-$compteur.txt>\n" >> corpus_ctx-$4.txt
			cat ./CONTEXTES/$4-$compteur.txt >> corpus_ctx-$4.txt
			echo -e "\n</fichier>\n" >> corpus_ctx-$4.txt
			nbmotif=$(egrep -coi "$3" ./DUMP-TEXT/$4-$compteur.txt)
			perl5.28.0.exe ./minigrep/minigrepmultilingue.pl "utf-8" ./DUMP-TEXT/$4-$compteur.txt ./minigrep/motif-regexp.txt
			mv resultat-extraction.html ./CONTEXTES/$4-$compteur.html
			egrep -o "\w+" ./DUMP-TEXT/$4-$compteur.txt | sort | uniq -c | sort -r > ./DUMP-TEXT/$4-$compteur-index.txt
			egrep -o "\w+" ./DUMP-TEXT/$4-$compteur.txt > bi1.txt
			tail -n +2 bi1.txt > bi2.txt
			tail -n +2 bi2.txt > bi3.txt
			paste bi1.txt bi2.txt > big.txt
			paste big.txt bi3.txt > tri.txt
			cat big.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$4-$compteur-bigramme.txt
			cat tri.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$4-$compteur-trigramme.txt
			echo "<tr align=\"center\">
					<td><FONT color=\"white\">$4-$compteur</FONT></td>
					<td><FONT color=\"white\">$code_sortie</FONT></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a target='_blank' href='$ligne' style='text-decoration: none'>
						<FONT color=\"white\">Lien $compteur</FONT>
						</a></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a target='_blank' href='../PAGES-ASPIREES/$4-$compteur.html' style='text-decoration: none'>
						<FONT color=\"white\">Aspirée $compteur</FONT>
						</a></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a target='_blank' href='../DUMP-TEXT/$4-$compteur.txt' style='text-decoration: none'>
						<FONT color=\"white\">Dump $compteur</FONT>
						</a></td>
					<td><FONT color=\"white\">$encodage</FONT></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a href=\"../CONTEXTES/$4-$compteur.txt\" style='text-decoration: none'>
						<FONT color=\"white\">Ctx $compteur</FONT>
						</a></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a href=\"../CONTEXTES/$4-$compteur.html\" style='text-decoration: none'>
						<FONT color=\"white\">Ctx HTML $compteur</FONT>
						</a></td>
					<td><FONT color=\"white\">$nbmotif</FONT></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a href=\"../DUMP-TEXT/$4-$compteur-index.txt\" style='text-decoration: none'>
						<FONT color=\"white\">Index $compteur</FONT>
						</a></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a href=\"../DUMP-TEXT/$4-$compteur-bigramme.txt\" style='text-decoration: none'>
						<FONT color=\"white\">Bigr $compteur</FONT>
						</a></td>
					<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
					onmouseout=\"this.style.backgroundColor='9370DB';\">
						<a href=\"../DUMP-TEXT/$4-$compteur-trigramme.txt\" style='text-decoration: none'>
						<FONT color=\"white\">Trigr $compteur</FONT>
						</a></td>
				</tr>" >> $2
		else
			reponse=$(iconv -l | egrep "$encodage")
			if [[ $reponse != "" ]]
			then
				if [[ $encodage != "" ]]
				then
					lynx --assume-charset="UTF-8" --display-charset="UTF-8" -dump -nolist $ligne > ./DUMP-TEXT/$4-$compteur-$encodage.txt
					iconv -s -f "$encodage" -t "UTF-8" ./DUMP-TEXT/$4-$compteur-$encodage.txt > ./DUMP-TEXT/$4-$compteur.txt
					echo -e "<fichier: $4-$compteur.txt>\n" >> corpus-$4.txt
					cat ./DUMP-TEXT/$4-$compteur.txt >> corpus-$4.txt
					echo -e "\n</fichier>\n" >> corpus-$4.txt
					egrep -i "$3" ./DUMP-TEXT/$4-$compteur.txt > ./CONTEXTES/$4-$compteur.txt
					echo -e "<fichier: $4-$compteur.txt>\n" >> corpus_ctx-$4.txt
					cat ./CONTEXTES/$4-$compteur.txt >> corpus_ctx-$4.txt
					echo -e "\n</fichier>\n" >> corpus_ctx-$4.txt
					nbmotif=$(egrep -coi "$3" ./DUMP-TEXT/$4-$compteur.txt)
					perl5.28.0.exe ./minigrep/minigrepmultilingue.pl "utf-8" ./DUMP-TEXT/$4-$compteur.txt ./minigrep/motif-regexp.txt
					mv resultat-extraction.html ./CONTEXTES/$4-$compteur.html
					egrep -o "\w+" ./DUMP-TEXT/$4-$compteur.txt | sort | uniq -c | sort -r > ./DUMP-TEXT/$4-$compteur-index.txt
					egrep -o "\w+" ./DUMP-TEXT/$4-$compteur.txt > bi1.txt
					tail -n +2 bi1.txt > bi2.txt
					tail -n +2 bi2.txt > bi3.txt
					paste bi1.txt bi2.txt > big.txt
					paste big.txt bi3.txt > tri.txt
					cat big.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$4-$compteur-bigramme.txt
					cat tri.txt | sort | uniq -c | sort -r >  ./DUMP-TEXT/$4-$compteur-trigramme.txt
					echo "<tr align = 'center'>
							<td><FONT color=\"white\">$4-$compteur</FONT></td>
							<td><FONT color=\"white\">$code_sortie</FONT></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a target='_blank' href='$ligne' style='text-decoration: none'>
								<FONT color=\"white\">Lien $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a target='_blank' href='../PAGES-ASPIREES/$4-$compteur.html' style='text-decoration: none'>
								<FONT color=\"white\">Aspirée $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a target='_blank' href='../DUMP-TEXT/$4-$compteur.txt' style='text-decoration: none'>
								<FONT color=\"white\">Dump $compteur</FONT>
								</a></td>
							<td><FONT color=\"white\">$encodage</FONT></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a href=\"../CONTEXTES/$4-$compteur.txt\" style='text-decoration: none'>
								<FONT color=\"white\">Ctx $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a href=\"../CONTEXTES/$4-$compteur.html\" style='text-decoration: none'>
								<FONT color=\"white\">Ctx HTML $compteur</FONT>
								</a></td>
							<td><FONT color=\"white\">$nbmotif</FONT></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a href=\"../DUMP-TEXT/$4-$compteur-index.txt\" style='text-decoration: none'>
								<FONT color=\"white\">Index $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a href=\"../DUMP-TEXT/$4-$compteur-bigramme.txt\" style='text-decoration: none'>
								<FONT color=\"white\">Bigr $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a href=\"../DUMP-TEXT/$4-$compteur-trigramme.txt\" style='text-decoration: none'>
								<FONT color=\"white\">Trigr $compteur</FONT>
								</a></td>
						</tr>" >> $2
				else
					echo -e "PB Encodage...$4::$compteur::$code_sortie::$encodage::$ligne\n"
					echo "<tr align = 'center'>
							<td><FONT color=\"white\">$4-$compteur</FONT></td>
							<td><FONT color=\"white\">$code_sortie</FONT></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a target='_blank' href='$ligne' style='text-decoration: none'>
								<FONT color=\"white\">Lien $compteur</FONT>
								</a></td>
							<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
							onmouseout=\"this.style.backgroundColor='9370DB';\">
								<a target='_blank' href='../PAGES-ASPIREES/$4-$compteur.html' style='text-decoration: none'>
								<FONT color=\"white\">Aspirée $compteur</FONT>
								</a></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
							<td><FONT color=\"white\">-</FONT></td>
						</tr>" >> $2
				fi
			else
				echo -e "PB Encodage...$4::$compteur::$code_sortie::$encodage::$ligne\n"
				echo "<tr align = 'center'>
						<td><FONT color=\"white\">$4-$compteur</FONT></td>
						<td><FONT color=\"white\">$code_sortie</FONT></td>
						<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
						onmouseout=\"this.style.backgroundColor='9370DB';\">
							<a target='_blank' href='$ligne' style='text-decoration: none'>
							<FONT color=\"white\">Lien $compteur</FONT>
							</a></td>
						<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
						onmouseout=\"this.style.backgroundColor='9370DB';\">
							<a target='_blank' href='../PAGES-ASPIREES/$4-$compteur.html' style='text-decoration: none'>
							<FONT color=\"white\">Aspirée $compteur</FONT>
							</a></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
						<td><FONT color=\"white\">-</FONT></td>
					</tr>" >> $2
			fi
		fi
	else
		echo -e "PB URL...$4::$compteur::$code_sortie::::$ligne\n"
		echo "<tr align = 'center'>
				<td><FONT color=\"white\">$4-$compteur</FONT></td>
				<td><FONT color=\"red\">$code_sortie</FONT></td>
				<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
				onmouseout=\"this.style.backgroundColor='9370DB';\">
					<a target='_blank' href='$ligne' style='text-decoration: none'>
					<FONT color=\"white\">Lien $compteur</FONT>
					</a></td>
				<td onmouseover=\"this.style.backgroundColor='7b68ee';\"
				onmouseout=\"this.style.backgroundColor='9370DB';\">
					<a target='_blank' href='../PAGES-ASPIREES/$4-$compteur.html' style='text-decoration: none'>
					<FONT color=\"white\">Aspirée $compteur</FONT>
					</a></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
				<td><FONT color=\"white\">-</FONT></td>
			</tr>" >> $2
	fi
	compteur=$((compteur+1)) 
	done
echo "</table>" >> $2
egrep -o "\w+" ./corpus-$4.txt | sort | uniq -c | sort -r > corpus-$4-index.txt
egrep -o "\w+" ./corpus_ctx-$4.txt | sort | uniq -c | sort -r > corpus_ctx-$4-index.txt
echo "<table border=\"1\" bordercolor=\"white\" align=\"center\" width=\"75%\">
	<tr align = 'center'>
		<td width=\"25%\" onmouseover=\"this.style.backgroundColor='7b68ee';\"
		onmouseout=\"this.style.backgroundColor='9370DB';\">
			<a target='_blank' href='../corpus-$4.txt' style='text-decoration: none'>
			<FONT color=\"white\">Corpus $4</FONT>
			</a></td>
		<td width=\"25%\" onmouseover=\"this.style.backgroundColor='7b68ee';\"
		onmouseout=\"this.style.backgroundColor='9370DB';\">
			<a target='_blank' href='../corpus_ctx-$4.txt' style='text-decoration: none'>
			<FONT color=\"white\">Contexte $4</FONT>
			</a></td>
		<td width=\"25%\" onmouseover=\"this.style.backgroundColor='7b68ee';\"
		onmouseout=\"this.style.backgroundColor='9370DB';\">
			<a target='_blank' href='../corpus-$4-index.txt' style='text-decoration: none'>
			<FONT color=\"white\">Corpus index $4</FONT>
			</a></td>
		<td width=\"25%\" onmouseover=\"this.style.backgroundColor='7b68ee';\"
		onmouseout=\"this.style.backgroundColor='9370DB';\">
			<a target='_blank' href='../corpus_ctx-$4-index.txt' style='text-decoration: none'>
			<FONT color=\"white\">Contexte index $4</FONT>
			</a></td>
	</tr></table>" >> $2

echo "</body>" >> $2
echo "</html>" >> $2