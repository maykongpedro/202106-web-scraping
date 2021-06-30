


#  1. colete os dados de mananciais da sabesp -----------------------------

# Essa url foi pega do headers dentro do network da página da SABESP  
u_sabesp <- "http://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/2020-03-15"
r_sabesp <- httr::GET(u_sabesp)
results <- httr::content(r_sabesp, simplifyDataFrame = TRUE)
results$ReturnObj$sistemas



#  2. separar informações e parâmetros ------------------------------------

dia <- "2021-06-07"

# com https ele entra com requisição segura
#url_base <- "https://mananciais.sabesp.com.br/api/"

# sem requisição segura
url_base <- "http://mananciais.sabesp.com.br/api/"

endpoint <- "Mananciais/ResumoSistemas/"

u <- paste0(url_base, endpoint, dia)

print(u)


# para ignorar a segurança de página na base da bicuda
# r <- httr::GET(u, httr::config(ssl_verifypeer = FALSE))

r <- httr::GET(u)




# verificando o que extrair
r |> 
    # objeto ReturnObj$sistemas retorna uma tabela
    httr::content(simplifyDataFrame = TRUE) |> 

    # pegando a tabela
    purrr::pluck("ReturnObj", "sistemas") |> 
    
    # transformando em tibble
    tibble::as_tibble() |> 
    
    # ajustando nome das colunas
    janitor::clean_names()



# Testando função ---------------------------------------------------------

# Obter os últimso 10 dias
dias <- Sys.Date() - 1:10

# Nomear os dias com os próprios dias
names(dias) <- dias


# Criando função
baixa_e_processa_sabesp <- function(dia){
    
    # obtenção dos dados
    url_base <- "http://mananciais.sabesp.com.br/api/"
    endpoint <- "Mananciais/ResumoSistemas/"
    u <- paste0(url_base, endpoint, dia)
    r <- httr::GET(u)
    
    # faxina
    dados <- r |> 
        httr::content(simplifyDataFrame = TRUE) |> 
        purrr::pluck("ReturnObj", "sistemas") |> 
        tibble::as_tibble() |> 
        janitor::clean_names()
    
    dados
    
}
    

# Rodando a função para todos os dias do objeto 'dias'
da_sabesp <-
    dias |>
    purrr::map_dfr(baixa_e_processa_sabesp,
                   .id = "data")

    

# Fazendo a função separadamente ------------------------------------------

dir.create("output/01-sabesp")

path <- "output/01-sabesp/"

baixar_sabesp <- function(dia, path) {
    url_base <- "http://mananciais.sabesp.com.br/api/"
    endpoint <- "Mananciais/ResumoSistemas/"
    u <- paste0(url_base, endpoint, dia)
    r <- httr::GET(u,
                   httr::write_disk(paste0(path,
                                           dia,
                                           ".json")))
    
}


processar_sabesp <- function(arquivo){
    
    dados <- arquivo |> 
        jsonlite::read_json(simplifyDataFrame = TRUE) |> 
        purrr::pluck("ReturnObj", "sistemas") |> 
        tibble::as_tibble() |> 
        janitor::clean_names()
    dados
}


# Passo 1: baixar
purrr::map(dias, baixar_sabesp, path)


# Passo 2: processar
da_sabesp <- fs::dir_ls(path) |> 
    purrr::map_dfr(processar_sabesp, .id = "data")

da_sabesp
