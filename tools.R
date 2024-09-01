
#rm(list = ls())

library(pdftools)
n = stringr::str_locate(getwd(),"Documents")[2]
datadir = paste0(stringr::str_sub(getwd(),1,n),"/data/jo/")
rm(n)
pdf_file <- paste0(datadir,"joe_20240901_0208_p000.pdf")
text <- pdf_text(pdf_file)
mot_recherche <- "dgac" # Remplace par le mot que tu veux rechercher


# Rechercher un mot spécifique dans le texte
mot_trouve <- grepl(mot_recherche, text, ignore.case = TRUE)
# Afficher les résultats
if(any(mot_trouve)) {
  cat("Le mot", mot_recherche, "a été trouvé dans le document.\n")
} else {
  cat("Le mot", mot_recherche, "n'a pas été trouvé dans le document.\n")
}

# Extraire les lignes contenant le mot recherché
lignes_avec_mot <- unlist(lapply(text, function(page) {
  # Découper la page en lignes
  lignes <- unlist(strsplit(page, "\n"))
  # Filtrer les lignes contenant le mot recherché
  lignes_avec_mot <- lignes[grepl(mot_recherche, lignes, ignore.case = TRUE)]
  return(lignes_avec_mot)
}))

# Vérifier si des lignes ont été trouvées
if(length(lignes_avec_mot) > 0) {
  # Enregistrer les lignes dans un fichier texte
  writeLines(lignes_avec_mot, "lignes_avec_mot.txt")
  cat("Les lignes contenant le mot", mot_recherche, "ont été enregistrées dans 'lignes_avec_mot.txt'.\n")
} else {
  cat("Aucune ligne contenant le mot", mot_recherche, "n'a été trouvée dans le document.\n")
}
