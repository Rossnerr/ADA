#include <omp.h>
#include <iostream> 
#include <cstdint>
#include <chrono>
#include <mutex>
#include "sha256.h"

std::mutex mtx;

void solve_crypto_puzzle(std::string message, uint puzzle_difficulty, int start, int step, std::string& solution)
{
    std::string nonce_needle(puzzle_difficulty, '0');
    SHA256 sha256;

    for(uint64_t i = start; i < UINT64_MAX; i += step){
        if (solution.length() != 0){
            return;
        }

        std::string solution_candidate = message + std::to_string(i);
        std::string hash_code = sha256(solution_candidate);

        if(hash_code.compare(0, puzzle_difficulty, nonce_needle) == 0){
            solution = solution_candidate;
        }
    }

    throw "No result found";
}

void check_comandline_passed_arguments(int argc, char *argv[])
{
    char* app_name = argv[0];
    if(argc == 1){
        std::cout << "Call application "<< app_name << " with arguments [n]." << std::endl;
        std::cout << "Example:" << std::endl;
        std::cout << app_name <<" 7 -- Application will try to solve crypto puzzle SHA256 with nonce that will generate 7 trailing 0 of the hashed message." << std::endl;
        std::cout << app_name <<" 8 -- Application will try to solve crypto puzzle SHA256 with nonce that will generate 8 trailing 0 of the hashed message." << std::endl;

        exit(0);
    }
    if(argc > 2)
    {
        std::cout << "Incorrect arguments passed." << std::endl;
        std::cout << "Call application "<< app_name << " for help message" << std::endl;

        exit(1);
    }
}

int main (int argc, char *argv[]) 
{
    check_comandline_passed_arguments(argc, argv);

    int difficulty = atoi(argv[1]);
    SHA256 sha256;
    const std::string message("Hello World");

    std::cout << "Message: " << std::endl << message;
    std::cout << "Hash: " << std::endl << sha256(message) << std::endl;
    std::cout << std::endl;
    std::cout << "Looking for nonce to solve crypto-puzzle with difficulty " << difficulty << "..." << std::endl;
    std::cout << "Application with OpenMP parameters:" << std::endl;

    auto t1 = std::chrono::high_resolution_clock::now();
    int total_threads, current_thread_id;
    std::string solution("");

    #pragma omp parallel num_threads(32) private(total_threads, current_thread_id)
    {
        current_thread_id = omp_get_thread_num();
        total_threads = omp_get_num_threads();
        mtx.lock();
        std::cout << "Total threads: " << total_threads << std::endl;
        std::cout << "Current thread: " << current_thread_id << std::endl;
        mtx.unlock();

        solve_crypto_puzzle(message, difficulty, current_thread_id, total_threads, solution);
    }
    std::cout << "Solution: " << std::endl << solution << std::endl;
    std::cout << "Hash:" << std::endl << sha256(solution) << std::endl;

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration_milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

    std::cout << duration_milliseconds.count() << " milliseconds" << std::endl;
}
