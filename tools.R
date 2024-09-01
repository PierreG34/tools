#rm(list = ls())

mot_recherche <- "statisti" # Remplace par le mot que tu veux rechercher

library(pdftools)
n = stringr::str_locate(getwd(),"Documents")[2]
datadir = paste0(stringr::str_sub(getwd(),1,n),"/data/jo/")
rm(n)

pdf_file <- paste0(datadir,"joe_20240901_0208_p000.pdf")
text <- pdf_text(pdf_file)

# Initialiser un dataframe pour stocker les résultats
resultats_df <- data.frame(
  Page = integer(),
  Ligne = integer(),
  Char_Start = integer(),
  Char_End = integer(),
  Texte = character(),
  stringsAsFactors = FALSE
)

# Parcourir chaque page du document
for (i in seq_along(text)) {
  # Découper la page en lignes
  lignes <- unlist(strsplit(text[[i]], "\n"))
  
  # Parcourir chaque ligne avec son numéro
  for (j in seq_along(lignes)) {
    # Chercher toutes les occurrences du mot dans la ligne
    positions <- gregexpr(mot_recherche, lignes[j], ignore.case = TRUE)[[1]]
    
    # Si le mot est trouvé dans la ligne
    if (positions[1] != -1) {
      for (pos in positions) {
        # Ajouter une ligne au dataframe pour chaque occurrence trouvée
        resultats_df <- rbind(resultats_df, data.frame(
          Page = i,
          Ligne = j,
          Char_Start = pos,
          Char_End = pos + nchar(mot_recherche) - 1,
          Texte = lignes[j],
          stringsAsFactors = FALSE
        ))
      }
    }
  }
}

nb = nrow(resultats_df)
# Vérifier si des lignes ont été trouvées
if(nb > 0) {
  # Enregistrer les résultats dans un fichier CSV
  #write.csv(resultats_df, "resultats_recherche.csv", row.names = FALSE)
  cat(nb,"lignes contiennent le mot", mot_recherche)
} else {
  cat("Aucune ligne contient le mot", mot_recherche)
}

# Afficher le dataframe des résultats
#print(resultats_df)
