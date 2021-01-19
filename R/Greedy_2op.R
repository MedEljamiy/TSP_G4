villes <- function(n){
  max_x <- 20000
  max_y <- 20000
  set.seed(9999779)
  villes <- data.frame(id = 1:n, x = runif(n, max = max_x),y = runif(n, max = max_y))
  return(villes)
}

D_distance <- function(n) {
  return(as.matrix(stats::dist(villes(n), diag = TRUE, upper = TRUE)))
}

Greedy_2opt<-function(n){
  Distance<-D_distance(n)
  N <- sqrt(length(Distance))
  DISTANCE <- matrix(rep(0,N^2),N,N)
  distance <- matrix(Distance,N,N)
  objective_list <- list()
  for(initial in 1:N){
    i = initial
    DISTANCE[,i] <- 1000
    order <- i
    for (i in 1:N){distance[i,i] = 10000}
    #-------------------------------------------------------------
    # Tour Construction : "GREEDY FUNCTION"
    #-------------------------------------------------------------
    while( length(order)<N ) {
      degree <- TRUE
      DISTANCE <- distance
      while( degree ) {
        j <- which.min(DISTANCE[i,])
        if (!(j %in% order)){
          order <- c(order, j)
          degree <- FALSE
        }
        else { DISTANCE[i,j] <- 100000 }
      }
      i = j
      print(j)
    }
    order
    #-------------------------------------------------------------
    #
    # Tour Improvement : "2-opt"
    #
    #-------------------------------------------------------------

    adjacency_list <- list() # create adjacency list
    k <- 1
    for(k in 1:(N-1)){
      adjacency_list[[k]] <- c(order[k],order[k+1])
    }
    adjacency_list[[N]] <- c(order[N], order[1])
    adjacency_list
    objective <- function(graph, distance){
      cost <- 0
      for(y in 1:length(graph)){
        cost <- cost + distance[graph[[y]][1], graph[[y]][2]]
      }
      cost
    }
    #-------------------------------------------------------------------------------------------

    ADJACENCY_LIST <- adjacency_list
    OBJECTIVE_LIST <- objective(adjacency_list, distance )
    for (k in 1:(N-1)){
      for(h in (k+1):N){
        #--------------------------------------------------------------------------
        # EXCHANGE EDGES
        #--------------------------------------------------------------------------
        if ((ADJACENCY_LIST[[k]][1] != ADJACENCY_LIST[[h]][1]) && (ADJACENCY_LIST[[k]][1] !=ADJACENCY_LIST[[h]][2])) {
          ADJACENCY_LIST[[k]] <- c(adjacency_list[[k]][1], adjacency_list[[h]][1])
          ADJACENCY_LIST[[h]] <- c(adjacency_list[[k]][2], adjacency_list[[h]][2])
        }
        #--------------------------------------------------------------------------
        # Check the goodness of the new adjacency list
        #--------------------------------------------------------------------------
        if ( objective(ADJACENCY_LIST, distance ) < objective(adjacency_list, distance ) ) {
          OBJECTIVE_LIST <- c( OBJECTIVE_LIST, objective(ADJACENCY_LIST, distance ))
          sub_order <- order[which(order==adjacency_list[[k]][2]): which(order== adjacency_list[[h]][1])]
          position <- NULL
          for(i in sub_order){
            position <- c(position, which(order == i))
          }
          rev_position <- rev(position)
          ORDER <- order
          for (t in 1:length(position)){
            ORDER[position[t]] <- order[rev_position[t]]
          }
          order <- ORDER
          for(k in 1:(N-1)){
            adjacency_list[[k]] <- c(order[k],order[k+1])
          }
          adjacency_list[[N]] <- c(order[N], order[1])
        }
        ADJACENCY_LIST <- adjacency_list
      }
    }
    objective_list[[initial]] <- OBJECTIVE_LIST
    print(OBJECTIVE_LIST)
  }
}
