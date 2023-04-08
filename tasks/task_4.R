sql_4 <- function(Posts, Users) {
    # Dla każdego użytkownika zliczamy liczbę pytań i odpowiedzi których udzielił.
    # Następnie wybieramy tylko tych użytkowników, którzy udzielili więcej odpowiedzi niż pytań.
    # Na końcu, dla 5 użytkowników z największą liczbą udzielonych odpowiedzi,
    # wyświetlamy ich nazwę, liczbę pytań i odpowiedzi, lokalizację, reputację oraz liczbę głosów pozytywnych i negatywnych.
    sqldf("
    SELECT DisplayName, QuestionsNumber, AnswersNumber, Location, Reputation, UpVotes, DownVotes
    FROM (
        SELECT *
        FROM (
            SELECT COUNT(*) as AnswersNumber, OwnerUserId
            FROM Posts
            WHERE PostTypeId = 2
            GROUP BY OwnerUserId
        ) AS Answers
        JOIN
        (
            SELECT COUNT(*) as QuestionsNumber, OwnerUserId
            FROM Posts
            WHERE PostTypeId = 1
            GROUP BY OwnerUserId
        ) AS Questions
        ON Answers.OwnerUserId = Questions.OwnerUserId
        WHERE AnswersNumber > QuestionsNumber
        ORDER BY AnswersNumber DESC
        LIMIT 5
    ) AS PostsCounts
    JOIN Users
    ON PostsCounts.OwnerUserId = Users.Id")
}

base_4 <- function(Posts, Users) {
    Answers <- Posts[Posts$PostTypeId == 2, ] # tworzymy tabelę z liczbą odpowiedzi
    Answers <- aggregate(Answers$OwnerUserId, by = Answers["OwnerUserId"], FUN = length) # dla każdego użytkownika zliczamy liczbę odpowiedzi
    colnames(Answers) <- c("OwnerUserId", "AnswersNumber") # nazywamy kolumny

    Questions <- Posts[Posts$PostTypeId == 1, ] # tworzymy tabelę z liczbą pytań
    Questions <- aggregate(Questions$OwnerUserId, by = Questions["OwnerUserId"], FUN = length) # dla każdego użytkownika zliczamy liczbę pytań
    colnames(Questions) <- c("OwnerUserId", "QuestionsNumber") # nazywamy kolumny

    PostsCounts <- merge(Answers, Questions, by = "OwnerUserId") # łączymy tabele z liczbą odpowiedzi i pytań
    PostsCounts <- PostsCounts[PostsCounts$AnswersNumber > PostsCounts$QuestionsNumber, ] # wybieramy tylko te wiersze, w których liczba odpowiedzi jest większa od liczby pytań
    PostsCounts <- PostsCounts[order(PostsCounts$AnswersNumber, decreasing = TRUE), ][1:5, ] # sortujemy po liczbie odpowiedzi malejąco i wybieramy 5 pierwszych wyników

    (
        merge(Users, PostsCounts, by.y = "OwnerUserId", by.x = "Id") # łączymy tabelę Users z PostsCounts
        [, c("DisplayName", "QuestionsNumber", "AnswersNumber", "Location", "Reputation", "UpVotes", "DownVotes")] # wybieramy potrzebne kolumny
    )
}

dplyr_4 <- function(Posts, Users) {
    Posts %>%
        group_by(OwnerUserId, ) %>% # grupujemy po id użytkownika
        summarise(AnswersNumber = sum(PostTypeId == 2), QuestionsNumber = sum(PostTypeId == 1)) %>% # dla każdego użytkownika zliczamy liczbę odpowiedzi i pytań
        filter(AnswersNumber > QuestionsNumber) %>% # wybieramy tylko te wiersze, w których liczba odpowiedzi jest większa od liczby pytań
        arrange(desc(AnswersNumber)) %>% # sortujemy po liczbie odpowiedzi malejąco
        slice_head(n = 6) %>% # wybieramy 5 pierwszych wierszy
        inner_join(Users, by = c("OwnerUserId" = "Id")) %>% # łączymy z tabelą Users
        select(DisplayName, QuestionsNumber, AnswersNumber, Location, Reputation, UpVotes, DownVotes) # wybieramy potrzebne kolumny
}

table_4 <- function(Posts, Users) {
    (
        setorder(
            (
                as.data.table(Posts) # konwertujemy do data.table
                [, .(AnswersNumber = sum(PostTypeId == 2), QuestionsNumber = sum(PostTypeId == 1)), by = OwnerUserId] # dla każdego użytkownika zliczamy liczbę odpowiedzi i pytań
                [AnswersNumber > QuestionsNumber, ] # wybieramy tylko te wiersze, w których liczba odpowiedzi jest większa od liczby pytań
            ),
            -AnswersNumber
        ) # sortujemy po liczbie odpowiedzi malejąco
        [1:6, ] # wybieramy 5 pierwszych wierszy
        [Users, on = .(OwnerUserId = Id), # łączymy z tabelą Users na podstawie kolumn OwnerUserId i Id
            nomatch = 0] # za brak dopasowania wstawiamy 0
        [, c("DisplayName", "QuestionsNumber", "AnswersNumber", "Location", "Reputation", "UpVotes", "DownVotes")] # wybieramy potrzebne kolumny
    )
}