#include <mpi.h>
#include "sha256.h"
#include <iostream> 
#include <cstdint>
#include <chrono>
#include <functional>


std::string solve_crypto_puzzle(std::string str, uint puzzle_difficulty, int start, int step, std::function<bool()> should_stop)
{
    std::string nonce_needle(puzzle_difficulty, '0');
    SHA256 sha256;

    for (uint64_t i = start; i < UINT64_MAX; i += step)
    {
        if (should_stop()) return "";
        std::string solution_candidate = str + std::to_string(i);
        std::string hash_code = sha256(solution_candidate);

        if (hash_code.compare(0, puzzle_difficulty, nonce_needle) == 0)
        {
            return solution_candidate;
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
    const int root = 0;
    const int SOLUTION_BUFFER_SIZE = 512;
    const int SOLUTION_TAG = 12;

    check_comandline_passed_arguments(argc, argv);

    int difficulty = atoi(argv[1]);
    SHA256 sha256;
    const std::string message("Hello World");

    std::cout << "Message: " << message << std::endl;
    std::cout << "Hash: " << sha256(message) << std::endl;
    std::cout << std::endl;
    std::cout << "Looking for nonce to solve crypto-puzzle with difficulty " << difficulty << "..." << std::endl;

    auto t1 = std::chrono::high_resolution_clock::now();

    // Initialize the MPI environment
    MPI_Init(NULL, NULL);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    std::cout << "Hello world from processor " << processor_name << ", rank " << world_rank << " out of " << world_size << " processors" << std::endl;

    if (world_rank != root) {
        auto found = true;
        MPI_Request receive_cancel_request;
        MPI_Ibcast(&found, 1, MPI_CXX_BOOL, root, MPI_COMM_WORLD, &receive_cancel_request);
        auto solution = solve_crypto_puzzle("Hello World", difficulty, world_rank - 1, world_size - 1,
            [&] () {
                int flag;
                MPI_Status status;
                MPI_Test(&receive_cancel_request, &flag, &status);
                return flag;
            });
        if (solution.length() != 0) {
            MPI_Send((void*)solution.data(), solution.length(), MPI_CHAR, root, SOLUTION_TAG, MPI_COMM_WORLD);
        }

        std::cout << "Process " << world_rank << " quits." << std::endl;
    }
    else if (world_rank == root) {
        char solution[SOLUTION_BUFFER_SIZE] = {};
        int solver_rank = -1;

        if (world_size > 1) {
            MPI_Status status;
            MPI_Recv(solution, SOLUTION_BUFFER_SIZE, MPI_CHAR, MPI_ANY_SOURCE, SOLUTION_TAG, MPI_COMM_WORLD, &status);
            solver_rank = status.MPI_SOURCE;
        }
        else {
            solver_rank = 1;
            auto solution_s = solve_crypto_puzzle(message, difficulty, 0, 1, [](){ return false; });
            solution_s.copy(solution, SOLUTION_BUFFER_SIZE);
        }
        
        auto t2 = std::chrono::high_resolution_clock::now();
        auto duration_milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

        std::cout 
            << "Process " << solver_rank << " found the solution" << std::endl
            << "Solution is " << solution << " with hash " << sha256(solution) << std::endl   
            << "In " << duration_milliseconds.count() << " milliseconds" << std::endl
            << std::fflush;

        if (world_size > 1) {
            auto found = true;
            MPI_Request send_cancel_request;
            MPI_Status send_cancel_status;
            MPI_Ibcast(&found, 1, MPI_CXX_BOOL, root, MPI_COMM_WORLD, &send_cancel_request);
            MPI_Wait(&send_cancel_request, &send_cancel_status);
        }
    }

    MPI_Finalize();
}