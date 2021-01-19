Nearest_neighbor=function(matrice_couts,ville_depart){
  C=matrice_couts # matrice des couts : ville de depart en ligne et ville d'arrivée en colonne
  V=ville_depart # initialisation ville de départ
  Trajet=c(V)# vecteur enregistrera le trajet du voyageur

  # Determination du trajet du voyageur
  for (i in 1:(nrow(C)-2)){
    C[,V]=1/0
    V=which.min(C[V,])
    Trajet=c(Trajet,V)
  }
  Trajet=c(Trajet,setdiff(1:nrow(C), Trajet),ville_depart)

  # Calcul du cout total du trajet
  Cout_total=0
  for (i in 1:nrow(C))
  {
    Cout_total=Cout_total+matrice_couts[Trajet[i],Trajet[i+1]]
  }

  # Retourner les resultats
  return_list=list(Trajet,Cout_total)
  names(return_list)=c("Trajet du vayageur","Cout total")
  return(return_list)
}
