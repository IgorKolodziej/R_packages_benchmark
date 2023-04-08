sql_5 <- function(Posts, Comments, Users) {
    # Wyliczamy sumę punktow za komentarze dla każdego posta,
    # łaczymy z tabelą Posts i wybieramy tylko pytania,
    # nastepnie laczymy z tabelą Users i wybieramy 10 pytań z największą sumą punktów za komentarze
    # i wyświetlamy ich tytuł, liczbę komentarzy, liczbę wyświetleń, sumę punktów za komentarze, nazwę użytkownika, reputację, lokalizację.
    CmtTotScr <- sqldf("SELECT PostId, SUM(Score) AS CommentsTotalScore
                        FROM Comments
                        GROUP BY PostId")
    PostsBestComments <- sqldf("
        SELECT Posts.OwnerUserId, Posts.Title, Posts.CommentCount, Posts.ViewCount,
                CmtTotScr.CommentsTotalScore
        FROM CmtTotScr
        JOIN Posts ON Posts.Id = CmtTotScr.PostId
        WHERE Posts.PostTypeId=1")

    sqldf("SELECT Title, CommentCount, ViewCount, CommentsTotalScore, DisplayName, Reputation, Location
            FROM PostsBestComments
            JOIN Users ON PostsBestComments.OwnerUserId = Users.Id
            ORDER BY CommentsTotalScore DESC
            LIMIT 10")
}

base_5 <- function(Posts, Comments, Users) {
    PostsBestComments <- Posts[Posts$PostTypeId == 1, ][, c("OwnerUserId", "Title", "CommentCount", "ViewCount", "Id")] # wybieramy tylko pytania i potrzebne kolumny

    CommentsTotalScore <- Comments[, c("PostId", "Score")] # wybieramy potrzebne kolumny
    CommentsTotalScore <- aggregate(CommentsTotalScore$Score, by = CommentsTotalScore["PostId"], FUN = sum) # dla każdego posta zliczamy sumę punktów za komentarze
    colnames(CommentsTotalScore) <- c("PostId", "CommentsTotalScore") # nazywamy kolumny

    PostsBestComments <- merge(PostsBestComments, CommentsTotalScore, by.x = "Id", by.y = "PostId") # łączymy tabele
    PostsBestComments <- PostsBestComments[order(-PostsBestComments$CommentsTotalScore), ][1:11, ] # sortujemy po sumie punktów za komentarze malejąco i wybieramy 10 pierwszych wierszy

    PostsBestComments <- merge(PostsBestComments, Users, by.x = "OwnerUserId", by.y = "Id") # łączymy z tabelą Users
    PostsBestComments[, c("Title", "CommentCount", "ViewCount", "CommentsTotalScore", "DisplayName", "Reputation", "Location")] # wybieramy potrzebne kolumny
}

dplyr_5 <- function(Posts, Comments, Users) {
    Posts %>%
        filter(PostTypeId == 1) %>% # wybieramy tylko pytania
        select(OwnerUserId, Title, CommentCount, ViewCount, Id) %>% # wybieramy potrzebne kolumny
        inner_join(
            Comments %>% # łączymy z przetworzoną tabelą Comments
                group_by(PostId) %>% # grupujemy Comments po postach
                summarise(CommentsTotalScore = sum(Score)) %>% # dla każdego posta zliczamy sumę punktów za komentarze
                select(PostId, CommentsTotalScore), # wybieramy potrzebne kolumny
            by = c("Id" = "PostId") # łączymy po kolumnie Id
        ) %>%
        select(-Id) %>% # usuwamy kolumnę Id
        arrange(desc(CommentsTotalScore)) %>% # sortujemy po sumie punktów za komentarze malejąco
        slice_head(n = 11) %>% # wybieramy 10 pierwszych wierszy
        inner_join(Users, by = c("OwnerUserId" = "Id")) %>% # łączymy z tabelą Users
        select(Title, CommentCount, ViewCount, CommentsTotalScore, DisplayName, Reputation, Location) # wybieramy potrzebne kolumny
}

table_5 <- function(Posts, Comments, Users) {
    (
        setorder(
            # Tworzymy i łączymy tabele PostsBestsComments i  CommentsTotalScore
            (as.data.table(Posts[Posts$PostTypeId == 1, ])[, c("OwnerUserId", "Title", "CommentCount", "ViewCount", "Id")] # wybieramy tylko pytania i potrzebne kolumny
            [as.data.table(Comments[, c("PostId", "Score")])[, .(CommentsTotalScore = sum(Score)), # dla każdego posta zliczamy sumę punktów za komentarze
                    by = PostId
                ], on = .(Id = PostId)] # łączymy po Id
            [as.data.table(Users), on = .(OwnerUserId = Id), # łączymy z tabelą Users
                nomatch = 0] # za brakujące wartości wstawiamy 0
            ),
            -CommentsTotalScore) # sortujemy po sumie punktów za komentarze malejąco
        [1:10, c("Title", "CommentCount", "ViewCount", "CommentsTotalScore", "DisplayName", "Reputation", "Location")] # wybieramy 10 pierwszych wierszy i potrzebne kolumny
    )
}