library(sqldf)
library(dplyr)
library(data.table)
library(microbenchmark)
library(ggplot2)
library(compare)
library(viridis)
library(gridExtra)

source("tasks/task_1.R")
source("tasks/task_2.R")
source("tasks/task_3.R")
source("tasks/task_4.R")
source("tasks/task_5.R")

Posts <- read.csv("data/posts.csv")
Users <- read.csv("data/users.csv")
Comments <- read.csv("data/comments.csv")
cat("----------------------------------------------------------------------------------\n")
# -----------------------------------------------------------------------------#
# Task 1
# -----------------------------------------------------------------------------#
print("Task 1")
print("Query result: ")
print(sql_1(Users))

print("Saving result to a file...")
write.csv(sql_1(Users), "queries_results/query_1.csv")
print("Result saved!")

print("Checking equality with sqldf:")
cat("Base 1: ")
print(compare(sql_1(Users), base_1(Users), allowAll = TRUE))
cat("Dplyr 1: ")
print(compare(sql_1(Users), dplyr_1(Users), allowAll = TRUE))
cat("Table 1: ")
print(compare(sql_1(Users), table_1(Users), allowAll = TRUE))

print("Benchmark 1:")
print("Benchmarking...")

benchmark_1 <- microbenchmark(
    sql_1(Users),
    base_1(Users),
    dplyr_1(Users),
    table_1(Users),
    times = 25
)

plot_1 <- (
    ggplot(benchmark_1, aes(x = expr, y = time, fill = expr)) +
        geom_boxplot() +
        scale_fill_viridis_d(option = "inferno") +
        labs(x = "Library", y = "Time (milliseconds)") +
        ggtitle("Benchmark 1") +
        scale_y_continuous(
            labels = function(x) format(x, scientific = TRUE, digits = 3),
            breaks = seq(0.5 * min(benchmark_1$time), max(benchmark_1$time) + 0.5*min(benchmark_1$time), by = 2*min(benchmark_1$time))
        ) +
        scale_x_discrete(labels = c("SQL", "Base", "Dplyr", "Table")) +
        theme(
            plot.title = element_text(size = 12, hjust = 0.5, vjust = -1.25),
            axis.title.x.bottom = element_text(size = 10, vjust = 2, hjust = 0.5),
            axis.title.y.left = element_text(size = 10, vjust = 0.5, hjust = 0.5),
            axis.text.x = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.text.y = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.ticks.x = element_blank(),
            legend.position = "none",
            panel.background = element_rect(fill = "#ffffffbe", color = "black"),
            plot.background = element_rect(fill = "#0095f8", color = "black"),
            text = element_text(color = "white", face = "bold"),
            axis.line = element_line(color = "black"),
            panel.grid.minor = element_line(color = "#bebebe4f"),
            panel.grid.major = element_line(color = "#100e9b")
        )
)

print("Benchmark results:")
print(benchmark_1)
print(plot_1)
print("Writing results to file...")
sink("benchmark_results/benchmark_1_results.txt")
print(benchmark_1)
sink()
png("plots/benchmark_1_plot.png", width = 1920, height = 1500, units = "px", res = 200)
print(plot_1)
dev.off()
print("Results saved!")
cat("----------------------------------------------------------------------------------\n")
# -----------------------------------------------------------------------------#
# Task 2
# -----------------------------------------------------------------------------#
print("Task 2")
print("Query result: ")
print(sql_2(Posts))

print("Saving result to a file...")
write.csv(sql_2(Posts), "queries_results/query_2.csv")
print("Result saved!")

print("Checking equality with sqldf:")
cat("Base 2: ")
print(compare(sql_2(Posts), base_2(Posts), allowAll = TRUE))
cat("Dplyr 2: ")
print(compare(sql_2(Posts), dplyr_2(Posts), allowAll = TRUE))
cat("Table 2: ")
print(compare(sql_2(Posts), table_2(Posts), allowAll = TRUE))

print("Benchmark 2:")
print("Benchmarking...")

benchmark_2 <- microbenchmark(
    sql_2(Posts),
    base_2(Posts),
    dplyr_2(Posts),
    table_2(Posts),
    times = 25
)

plot_2 <- (
    ggplot(benchmark_2, aes(x = expr, y = time, fill = expr)) +
        geom_boxplot() +
        scale_fill_viridis_d(option = "inferno") +
        labs(x = "Library", y = "Time (milliseconds)") +
        ggtitle("Benchmark 2") +
        scale_y_continuous(
            labels = function(x) format(x, scientific = TRUE, digits = 3),
            breaks = seq(0.5 * min(benchmark_2$time), max(benchmark_2$time) + 0.5 * min(benchmark_2$time), by = 2 * min(benchmark_2$time))
        ) +
        scale_x_discrete(labels = c("SQL", "Base", "Dplyr", "Table")) +
        theme(
            plot.title = element_text(size = 12, hjust = 0.5, vjust = -1.25),
            axis.title.x.bottom = element_text(size = 10, vjust = 2, hjust = 0.5),
            axis.title.y.left = element_text(size = 10, vjust = 0.5, hjust = 0.5),
            axis.text.x = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.text.y = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.ticks.x = element_blank(),
            legend.position = "none",
            panel.background = element_rect(fill = "#ffffffbe", color = "black"),
            plot.background = element_rect(fill = "#0095f8", color = "black"),
            text = element_text(color = "white", face = "bold"),
            axis.line = element_line(color = "black"),
            panel.grid.minor = element_line(color = "#bebebe4f"),
            panel.grid.major = element_line(color = "#100e9b")
        )
)

print("Benchmark results:")
print(benchmark_2)
plot_2
print("Writing results to file...")
sink("benchmark_results/benchmark_2_results.txt")
print(benchmark_2)
sink()
png("plots/benchmark_2_plot.png", width = 1920, height = 1500, units = "px", res = 200)
print(plot_2)
dev.off()
print("Results saved!")
cat("----------------------------------------------------------------------------------\n")
# -----------------------------------------------------------------------------#
# Task 3
# -----------------------------------------------------------------------------#
print("Task 3")
print("Query result: ")
print(sql_3(Posts, Users))

print("Saving result to a file...")
write.csv(sql_3(Posts, Users), "queries_results/query_3.csv")
print("Result saved!")

print("Checking equality with sqldf:")
cat("Base 3: ")
print(compare(sql_3(Posts, Users), base_3(Posts, Users), allowAll = TRUE))
cat("Dplyr 3: ")
print(compare(sql_3(Posts, Users), dplyr_3(Posts, Users), allowAll = TRUE))
cat("Table 3: ")
print(compare(sql_3(Posts, Users), table_3(Posts, Users), allowAll = TRUE))

print("Benchmark 3:")
print("Benchmarking...")

benchmark_3 <- microbenchmark( 
    sql_3(Posts, Users),
    base_3(Posts, Users),
    dplyr_3(Posts, Users),
    table_3(Posts, Users),
    times = 25
)

plot_3 <- (
    ggplot(benchmark_3, aes(x = expr, y = time, fill = expr)) +
        geom_boxplot() +
        scale_fill_viridis_d(option = "inferno") +
        labs(x = "Library", y = "Time (milliseconds)") +
        ggtitle("Benchmark 3") +
        scale_y_continuous(
            labels = function(x) format(x, scientific = TRUE, digits = 3),
            breaks = seq(0.5 * min(benchmark_3$time), max(benchmark_3$time) + 0.5 * min(benchmark_3$time), by = 2 * min(benchmark_3$time))
        ) +
        scale_x_discrete(labels = c("SQL", "Base", "Dplyr", "Table")) +
        theme(
            plot.title = element_text(size = 12, hjust = 0.5, vjust = -1.25),
            axis.title.x.bottom = element_text(size = 10, vjust = 2, hjust = 0.5),
            axis.title.y.left = element_text(size = 10, vjust = 0.5, hjust = 0.5),
            axis.text.x = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.text.y = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.ticks.x = element_blank(),
            legend.position = "none",
            panel.background = element_rect(fill = "#ffffffbe", color = "black"),
            plot.background = element_rect(fill = "#0095f8", color = "black"),
            text = element_text(color = "white", face = "bold"),
            axis.line = element_line(color = "black"),
            panel.grid.minor = element_line(color = "#bebebe4f"),
            panel.grid.major = element_line(color = "#100e9b")
        )
)

print("Benchmark results:")
print(benchmark_3)
print(plot_3)
print("Writing results to file...")
sink("benchmark_results/benchmark_3_results.txt")
print(benchmark_3)
sink()
png("plots/benchmark_3_plot.png", width = 1920, height = 1500, units = "px", res = 200)
print(plot_3)
dev.off()
print("Results saved!")
cat("----------------------------------------------------------------------------------\n")
# -----------------------------------------------------------------------------#
# Task 4
# -----------------------------------------------------------------------------#
print("Task 4")
print("Query result: ")
print(sql_4(Posts, Users))

print("Saving result to a file...")
write.csv(sql_4(Posts, Users), "queries_results/query_4.csv")
print("Result saved!")

print("Checking equality with sqldf:")
cat("Base 4: ")
print(compare(sql_4(Posts, Users), base_4(Posts, Users), allowAll = TRUE))
cat("Dplyr 4: ")
print(compare(sql_4(Posts, Users), dplyr_4(Posts, Users), allowAll = TRUE))
cat("Table 4: ")
print(compare(sql_4(Posts, Users), table_4(Posts, Users), allowAll = TRUE))

print("Benchmark 4:")
print("Benchmarking...")

benchmark_4 <- microbenchmark(
    sql_4(Posts, Users),
    base_4(Posts, Users),
    dplyr_4(Posts, Users),
    table_4(Posts, Users),
    times = 25
)

plot_4 <- (
    ggplot(benchmark_4, aes(x = expr, y = time, fill = expr)) +
        geom_boxplot() +
        scale_fill_viridis_d(option = "inferno") +
        labs(x = "Library", y = "Time (milliseconds)") +
        ggtitle("Benchmark 4") +
        scale_y_continuous(
            labels = function(x) format(x, scientific = TRUE, digits = 3),
            breaks = seq(0.5 * min(benchmark_4$time), max(benchmark_4$time) + 0.5 * min(benchmark_4$time), by = 2 * min(benchmark_4$time))
        ) +
        scale_x_discrete(labels = c("SQL", "Base", "Dplyr", "Table")) +
        theme(
            plot.title = element_text(size = 12, hjust = 0.5, vjust = -1.25),
            axis.title.x.bottom = element_text(size = 10, vjust = 2, hjust = 0.5),
            axis.title.y.left = element_text(size = 10, vjust = 0.5, hjust = 0.5),
            axis.text.x = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.text.y = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.ticks.x = element_blank(),
            legend.position = "none",
            panel.background = element_rect(fill = "#ffffffbe", color = "black"),
            plot.background = element_rect(fill = "#0095f8", color = "black"),
            text = element_text(color = "white", face = "bold"),
            axis.line = element_line(color = "black"),
            panel.grid.minor = element_line(color = "#bebebe4f"),
            panel.grid.major = element_line(color = "#100e9b")
        )
)

print("Benchmark results:")
print(benchmark_4)
print(plot_4)
print("Writing results to file...")
sink("benchmark_results/benchmark_4_results.txt")
print(benchmark_4)
sink()
png("plots/benchmark_4_plot.png", width = 1920, height = 1500, units = "px", res = 200)
print(plot_4)
dev.off()
print("Results saved!")
cat("----------------------------------------------------------------------------------\n")
# -----------------------------------------------------------------------------#
# Task 5
# -----------------------------------------------------------------------------#
print("Task 5")
print("Query result: ")
print(sql_5(Posts, Comments, Users))

print("Saving result to a file...")
write.csv(sql_5(Posts, Comments, Users), "queries_results/query_5.csv")
print("Result saved!")

print("Checking equality with sqldf:")
cat("Base 5: ")
print(compare(sql_5(Posts, Comments, Users), base_5(Posts, Comments, Users), allowAll = TRUE))
cat("Dplyr 5: ")
print(compare(sql_5(Posts, Comments, Users), dplyr_5(Posts, Comments, Users), allowAll = TRUE))
cat("Table 5: ")
print(compare(sql_5(Posts, Comments, Users), table_5(Posts, Comments, Users), allowAll = TRUE))

print("Benchmark 5:")
print("Benchmarking...")

benchmark_5 <- microbenchmark(
    sql_5(Posts, Comments, Users),
    base_5(Posts, Comments, Users),
    dplyr_5(Posts, Comments, Users),
    table_5(Posts, Comments, Users),
    times = 25
)

plot_5 <- (
    ggplot(benchmark_5, aes(x = expr, y = time, fill = expr)) +
        geom_boxplot() +
        scale_fill_viridis_d(option = "inferno") +
        labs(x = "Library", y = "Time (milliseconds)") +
        ggtitle("Benchmark 5") +
        scale_y_continuous(
            labels = function(x) format(x, scientific = TRUE, digits = 3),
            breaks = seq(0.5 * min(benchmark_5$time), max(benchmark_5$time) + 0.5 * min(benchmark_5$time), by = 2 * min(benchmark_5$time))
        ) +
        scale_x_discrete(labels = c("SQL", "Base", "Dplyr", "Table")) +
        theme(
            plot.title = element_text(size = 12, hjust = 0.5, vjust = -1.25),
            axis.title.x.bottom = element_text(size = 10, vjust = 2, hjust = 0.5),
            axis.title.y.left = element_text(size = 10, vjust = 0.5, hjust = 0.5),
            axis.text.x = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.text.y = element_text(size = 7, vjust = 0.5, hjust = 0.5),
            axis.ticks.x = element_blank(),
            legend.position = "none",
            panel.background = element_rect(fill = "#ffffffbe", color = "black"),
            plot.background = element_rect(fill = "#0095f8", color = "black"),
            text = element_text(color = "white", face = "bold"),
            axis.line = element_line(color = "black"),
            panel.grid.minor = element_line(color = "#bebebe4f"),
            panel.grid.major = element_line(color = "#100e9b")
        )
)


print("Benchmark results:")
print(benchmark_5)
print(plot_5)
print("Writing results to file...")
sink("benchmark_results/benchmark_5_results.txt")
print(benchmark_5)
sink()
png("plots/benchmark_5_plot.png", width = 1920, height = 1500, units = "px", res = 200)
print(plot_5)
dev.off()
print("Results saved!")

cat("----------------------------------------------------------------------------------\n")
print("Saving all benchmarks results to a file...")
sink("benchmark_results/all_benchmarks_results.txt")
print("All benchmarks results:")
cat("----------------------------------------------------------------------------------\n")
print("Benchmark 1:")
print(benchmark_1)
cat("----------------------------------------------------------------------------------\n")
print("Benchmark 2:")
print(benchmark_2)
cat("----------------------------------------------------------------------------------\n")
print("Benchmark 3:")
print(benchmark_3)
cat("----------------------------------------------------------------------------------\n")
print("Benchmark 4:")
print(benchmark_4)
cat("----------------------------------------------------------------------------------\n")
print("Benchmark 5:")
print(benchmark_5)
cat("----------------------------------------------------------------------------------\n")
sink()

png("plots/all_benchmarks_plots.png", width = 1920, height = 3000, units = "px", res = 200)
grid.arrange(plot_1, plot_2, plot_3, plot_4, plot_5, ncol = 2, top = "All benchmarks plots")
dev.off()

print("Benchmark results saved to benchmark_results folder.")
print("Benchmark plots saved to plots folder.")
print("Benchmarking finished!")
cat("----------------------------------------------------------------------------------\n")