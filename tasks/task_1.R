sql_1 <- function(Users) {
    # Grupujemy wyniki według lokalizacji (która nie może być pusta) i dla każdej wyliczamy sumę głosów pozytywnych,
    # na koniec pokazujemy 10 wyników z największą sumą głosów pozytywnych.
    sqldf("
    SELECT Location, SUM(UpVotes) as TotalUpVotes
    FROM Users
    WHERE Location != ''
    GROUP BY Location
    ORDER BY TotalUpVotes DESC
    LIMIT 10"
    )
}

base_1 <- function(Users) {
    df <- Users[Users$Location != "", ] # wybieramy tylko te wiersze, gdzie lokalizacja nie jest pusta
    df <- aggregate(df$UpVotes, df["Location"], FUN = sum) # grupujemy po lokalizacji i sumujemy głosy pozytywne
    colnames(df)[2] <- "TotalUpVotes" # nazywamy kolumnę z sumą głosów pozytywnych
    df[order(df$TotalUpVotes, decreasing = TRUE), ][1:10, ] # sortujemy malejąco po sumie głosów pozytywnych i pokazujemy tylko 10 pierwszych wyników
}

dplyr_1 <- function(Users) {
    Users %>%
        filter(Location != "") %>% # wybieramy tylko te wiersze, gdzie lokalizacja nie jest pusta
        select(Location, UpVotes) %>% # wybieramy kolumny z lokalizacją i głosami pozytywnymi
        group_by(Location) %>% # grupujemy po lokalizacji
        summarize(TotalUpVotes = sum(UpVotes)) %>% # sumujemy głosy pozytywne
        arrange(desc(TotalUpVotes)) %>% # sortujemy malejąco po sumie głosów pozytywnych
        slice_head(n = 10) # pokazujemy tylko 10 pierwszych wyników
}

table_1 <- function(Users) {
    (
        setorder(
            (as.data.table(Users) # konwertujemy do data.table
            [Location != "", ] # wybieramy tylko te wiersze, gdzie lokalizacja nie jest pusta
            [, .(TotalUpVotes = sum(UpVotes)), by = Location]), # grupujemy po lokalizacji i sumujemy głosy pozytywne
            -TotalUpVotes
        ) # sortujemy malejąco po sumie głosów pozytywnych
        [1:10, ] # pokazujemy tylko 10 pierwszych wyników
    )
}