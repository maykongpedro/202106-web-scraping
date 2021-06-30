library(httr)
library(magrittr)
library(jsonlite)

u_base <- "https://pokeapi.co/api/v2/"
endpoint <- "/pokemon/ditto"
u_pokemon <- paste0(u_base, endpoint)
r_pokemon <- httr::GET(u_pokemon)



# 1. Entenda a dif. entre essas formas de pegar o conteúdo do resultado -------


# Solta uma lista de informações sobre o pokemon escolhido (ditto)
httr::content(r_pokemon)

# Solta um resultado em forma de texto (difícil utilização)
httr::content(r_pokemon, "text")

# Solta um resultado em forma de uso de memória, seu uso é raro
httr::content(r_pokemon, "raw")

# Solta a lista padrão de infos. Basicamente ela roda a função jsonlite::fromJSON
# para transformar o "text" em uma lista organizada.
httr::content(r_pokemon, "parsed")

# Retorna a lista simplificada em um dataframe
httr::content(r_pokemon, "parsed", simplifyDataFrame = TRUE)

# Essa é a fórmula que é rodada dentrto do "content"
httr::content(r_pokemon, "text") |> 
  jsonlite::fromJSON()




# 2. Pegar informações filtrando com o código -----------------------------


# Definindo itens para a query
q_pokemon <- list(
  
  # queremos 8 pokemons por vez
  limit = 8, 
  
  # pulando a primeira geração
  offset = 1
)


# Fazendo uma query
r_pokemon_filtrado <- httr::GET(
  paste0(u_base, "/pokemon"), 
  
  # essa informação adiciona mais itens na url para seguir o filtro que definimos
  query = q_pokemon
)


# Acessa o conteúdo da query
httr::content(r_pokemon_filtrado, simplifyDataFrame = TRUE)




# 3. O que faz httr::write_disk()? ----------------------------------------

# Criar pasta de output no projeto
dir.create("output", showWarnings = FALSE, recursive = TRUE)

# Salvar a página da web/api em json no computador
httr::GET(
  paste0(u_base, "/pokemon"), 
  query = q_pokemon, 
  httr::write_disk("output/01-pokemon.json")
)

# Esse backup pode ser acessado pela função abaixo:
jsonlite::read_json("output/01-pokemon.json")
