
# Carregando apenas pipe
'%>%' <- magrittr::`%>%` 

# base
u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"


# 1. Baixe as posicoes pelo endpoint /Posicao
u_sptrans_busca <- paste0(u_sptrans, "/Posicao")
r_sptrans_busca <- httr::GET(u_sptrans_busca)
tab_sptrans <- httr::content(r_sptrans_busca, 
                             simplifyDataFrame = TRUE)

# Não autorizado
tab_sptrans


# usando token
api_key <- Sys.getenv("API_OLHO_VIVO")
u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")
q_sptrans_login <- list(token = api_key)

# usando POST com o token disponibiliado em aula
r_sptrans_login <- httr::POST(u_sptrans_login, 
                              query = q_sptrans_login)

# obtendo contéudo com GET e content
r_sptrans <- httr::GET(u_sptrans_busca)
httr::content(r_sptrans)

tab_sptrans <- httr::content(r_sptrans,
                             simplifyDataFrame = TRUE)


# 2. Rode tibble::glimpse(tab_sptrans$l, 50)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C
tibble::glimpse(tab_sptrans$l, 50)



# 3. Quantas/quais linhas de ônibus temos com o nome LAPA?
## Dica: descubra o endpoint e use um parâmetro de busca!




# 4. [extra] Escolha uma linha e obtenha a posição de todos os ônibus dessa linha.
# Obtenha uma tabela com as coordenadas de latitude e longitude.




# 5. [extra] use o pacote leaflet para montar um mapa contendo a posição de todos 
# os ônibus da linha.
