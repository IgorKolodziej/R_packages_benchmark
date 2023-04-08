sql_2 <- function(Posts) {
    # Wybieramy tylko posty typu 1 i 2 (pytania i odpowiedzi), grupujemy po roku i miesiącu,
    # a następnie wyliczamy liczbę postów oraz maksymalny wynik dla każdej grupy.
    # Pokazujemy rok, miesiąc, liczbę postów i maksymalny wynik w grupach, gdzie liczba postów jest większa od 1000.
    sqldf("SELECT STRFTIME('%Y', CreationDate) AS Year, STRFTIME('%m', CreationDate) AS Month,
    COUNT(*) AS PostsNumber, MAX(Score) AS MaxScore
    FROM Posts
    WHERE PostTypeId IN (1, 2)
    GROUP BY Year, Month
    HAVING PostsNumber > 1000"
    )
}

base_2 <- function(Posts) {
    df <- Posts[Posts$PostTypeId %in% c(1, 2), ] # wybieramy tylko posty typu 1 i 2

    df$Month <- substr(df$CreationDate, 6, 7) # wybieramy z daty miesiąc
    df$Year <- substr(df$CreationDate, 1, 4) # wybieramy z daty rok

    df <- aggregate(df$Score, df[c("Year", "Month")], function(x) c(length(x), max(x))) # grupujemy po roku i miesiącu, a następnie wyliczamy liczbę postów oraz maksymalny wynik dla każdej grupy

    df$PostsNumber <- df[, 3][, 1] # tworzymy kolumnę z liczbą postów na podstawie wynikowej kolumny z aggregate
    df$MaxScore <- df[, 3][, 2] # tworzymy kolumnę z maksymalnym wynikiem

    (
        df[df$PostsNumber > 1000, ] # wybieramy tylko grupy, w których liczba postów jest większa od 1000
        [c("Year", "Month", "PostsNumber", "MaxScore")] # wybieramy potrzebne kolumny
    )
}

dplyr_2 <- function(Posts) {
    Posts %>%
        filter(PostTypeId %in% c(1, 2)) %>% # wybieramy tylko posty typu 1 i 2
        mutate(Year = substr(CreationDate, 1, 4), Month = substr(CreationDate, 6, 7)) %>% # tworzymy kolumny z rokiem i miesiącem
        group_by(Year, Month) %>% # grupujemy po roku i miesiącu
        summarize(PostsNumber = n(), MaxScore = max(Score)) %>% # wyliczamy liczbę postów oraz maksymalny wynik dla każdej grupy
        filter(PostsNumber > 1000) # wybieramy tylko te grupy, w których liczba postów jest większa od 1000
}

table_2 <- function(Posts) {
    (
        as.data.table(Posts)[PostTypeId %in% c(1, 2), ] # wybieramy tylko posty typu 1 i 2
        [, Year := substr(CreationDate, 1, 4)] # tworzymy kolumnę z rokiem
        [, Month := substr(CreationDate, 6, 7)] # tworzymy kolumnę z miesiącem
        [, .(PostsNumber = .N, MaxScore = max(Score)), # wyliczamy liczbę postów oraz maksymalny wynik dla każdej grupy
            by = .(Year, Month)] # grupujemy po roku i miesiącu
        [PostsNumber > 1000] # wybieramy tylko grupy, w których liczba postów jest większa od 1000
    )
}