# Exercício resolvido no dia 30 jun.2021

# 1. Escreva uma função que recebe uma data e retorna a tabela dos mananciais -----
baixar_sabesp <- function(data) {

    u_base <- "http://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
    u <- paste0(u_base, data)
    r <- httr::GET(u)
    
    tab_mananciais <- r |> 
        
        # objeto ReturnObj$sistemas retorna uma tabela
        httr::content(simplifyDataFrame = TRUE) |> 
        
        # pegando a tabela
        purrr::pluck("ReturnObj", "sistemas") |> 
        
        # transformando em tibble
        tibble::as_tibble() |> 
        
        # ajustando nome das colunas
        janitor::clean_names()    
    
    return(tab_mananciais)

}



# 2. Armazene no objeto tab_sabesp a tabela do dia `Sys.Date() - 1` (ontem) -------

ontem <- Sys.Date()-1
tab_sabesp <- baixar_sabesp(ontem)


# 3. [extra] Arrume os dados para que fique assim: --------------------------------

# Observations: 7
# Variables: 2
# $ nome   <fct> Cantareira, Alto Tietê, Guarapiranga, Cotia, Rio Grande, Rio Claro, São Lourenço
# $ volume <dbl> 63.25681, 90.35307, 84.25839, 102.28429, 93.66445, 99.85615, 97.33682

ordem_fcts <- c("Cantareira", 
                "Alto Tietê",
                "Guarapiranga",
                "Cotia", 
                "Rio Grande", 
                "Rio Claro", 
                "São Lourenço")


tab_sabesp_arrumado <- tab_sabesp |> 
    dplyr::mutate(nome = factor(nome,
                                levels = ordem_fcts,
                                ordered = TRUE)) |> 
    dplyr::group_by(nome) |> 
    dplyr::summarise(volume = sum(volume_operacional))
    
tab_sabesp_arrumado
