# library(httr)
# library(magrittr)
# library(jsonlite)

# link base da api
u_base <- "https://pokeapi.co/api/v2/"


#  1. Acesse todos os resultados de "type" --------------------------------
# Dica: qual é o endpoint que devemos utilizar?

endpoint <- "type/3" # pego no site da api
u <- paste0(u_base, endpoint)

r <- httr::GET(u)

c <- httr::content(r, simplifyDataFrame = TRUE)
c



# 2. Encontre o link do type "grass" e guarde em um objeto. ---------------
# Dica: você pode fazer isso manualmente ou com um código em R, usando {purrr}

# verificando onde são citados os "types"
r |> httr::content(simplifyDataFrame = TRUE)

# encontrei eles na parte de "damage_relations"
# "grass" está dentro de 'double_damage_to' e 'half_damage_from'

url_grass <- r |> 
    httr::content() |> 
    purrr::pluck("damage_relations", "double_damage_to") |> 
    purrr::pluck(3, "url")

url_grass






# 3. Crie um data.frame com os 20 primeiros pokemons do tipo "grass" ------
# Dica: nesse caso, não dá para utilizar o parâmetro limit=""
# Dica: utilize o parâmetro query=.
# Além disso, tabelas ficam mais fáceis de visualizar quando rodamos 
# tibble::as_tibble(tab)


# definir query: pode ser definida antes em uma variável ou diretamente no parâmetro
q_type <- list(
    type = "grass"
)


# obtendo 20 primeiros pokemons do tipo "grass"
grass_pokemons <-
    httr::GET(url = url_grass,
              query = c(type = "grass")) |>
    httr::content(simplifyDataFrame = TRUE) |>
    purrr::pluck("pokemon") |>
    tibble::as_tibble() |>
    dplyr::slice(1:20)

grass_pokemons












