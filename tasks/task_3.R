sql_3 <- function(Posts, Users) {
    # Z tabeli Posts wybieramy tylko pytania, a następnie
    # dla każdego użytkownika sumujemy ilość ich wyświetleń.
    # Łączymy z tabelą Users na podstawie id użytkownika, aby uzyskać jego nazwę
    # i wybieramy 10 użytkowników z największą sumą wyświetleń.
    Questions <- sqldf(
        "SELECT OwnerUserId, SUM(ViewCount) as TotalViews
        FROM Posts
        WHERE PostTypeId = 1
        GROUP BY OwnerUserId"
    )

    sqldf("
            SELECT Id, DisplayName, TotalViews
            FROM Questions
            JOIN Users
            ON Users.Id = Questions.OwnerUserId
            ORDER BY TotalViews DESC
            LIMIT 10")
}

base_3 <- function(Posts, Users) {
    Questions <- Posts[Posts$PostTypeId == 1, ] # wybieramy tylko pytania
    Questions <- aggregate(Questions$ViewCount, Questions["OwnerUserId"], sum) # dla każdego użytkownika sumujemy ilość wyświetleń postów
    colnames(Questions) <- c("OwnerUserId", "TotalViews") # nadajemy nazwy kolumnom

    df <- merge(Users, Questions, by.x = "Id", by.y = "OwnerUserId") # łączymy z tabelą Users na podstawie id użytkownika

    (
        df[c("Id", "DisplayName", "TotalViews")] # wybieramy potrzebne kolumny
        [order(df$TotalViews, decreasing = TRUE), ] # sortujemy po ilości wyświetleń malejąco
        [1:10, ] # wybieramy 10 pierwszych wyników
    )
}

dplyr_3 <- function(Posts, Users) {
    Posts %>%
        filter(PostTypeId == 1) %>% # wybieramy tylko posty typu 1
        group_by(OwnerUserId) %>% # grupujemy po id użytkownika
        summarize(TotalViews = sum(ViewCount)) %>% # dla każdego użytkownika sumujemy ilość wyświetleń postów
        inner_join(Users, by = c("OwnerUserId" = "Id")) %>% # łączymy z tabelą Users na podstawie id użytkownika
        rename(Id = OwnerUserId) %>% # zmieniamy nazwę kolumny z id użytkownika
        select(Id, DisplayName, TotalViews) %>% # wybieramy potrzebne koluny
        arrange(desc(TotalViews)) %>% # sortujemy po ilości wyświetleń malejąco
        slice_head(n = 10) # wybieramy 10 pierwszych wyników
}

table_3 <- function(Posts, Users) {
    (
        setorder(
            as.data.table(Users)[
                as.data.table(Posts) # łączymy tabelę Users z tabelą Posts
                [Posts$PostTypeId == 1, .(TotalViews = sum(ViewCount)), # z Posts wybieramy tylko pytania i dla każdego użytkownika sumujemy ilość ich wyświetleń
                    by = .(OwnerUserId)], # i grupujemy po id użytkownika
                on = .(Id = OwnerUserId), # tabele łączymy na podstawie id użytkownika
                nomatch = 0
            ], # za brak dopasowania wpisujemy 0
            -TotalViews
        ) # sortujemy po ilości wyświetleń malejąco
        [1:10, .(Id, DisplayName, TotalViews)] # wybieramy 10 pierwszych wyników i potrzebne kolumny
    )
}