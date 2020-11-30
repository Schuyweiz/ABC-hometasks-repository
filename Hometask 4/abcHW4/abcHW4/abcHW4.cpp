
// c++ main.cpp -fopenmp
#include <omp.h>
#include <iostream>
#include <thread>
#include <vector>

bool check_same_digits(uint64_t a, uint64_t b)
{
	int c[10] = { 0 };
	int d[10] = { 0 };
	uint64_t temp_b = b;
	while (b > 0)
	{
		c[b % 10] = 1;
		b /= 10;
	}
	while (a > 0)
	{
		if (c[a % 10] == 0)
		{
			return false;
		}
		d[a % 10] = 1;
		a /= 10;
	}
	while (temp_b > 0)
	{
		if (d[temp_b % 10] == 0)
		{
			return false;
		}
		temp_b /= 10;
	}
	return true;
}



int main()
{
	int n;
	int threads_amt;
	printf("Enter the multiplication factor: ");
	std::cin >> n;
	printf("Enter the amount of threads to imply or enter 0 if you want openmp to deal with the amount: ");
	std::cin >> threads_amt;
	while (n < 2 || n > 9 || threads_amt < 0)
	{
		printf("Wrong values. 1<n<10 and amount of threads involved must be positive.\n");
		printf("Enter the multiplication factor: ");
		std::cin >> n;
		printf("Enter the amount of threads to imply: ");
		std::cin >> threads_amt;
	}
	if (threads_amt != 0)
	{
		omp_set_dynamic(0);
		omp_set_num_threads(threads_amt);
	}


	std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

	std::vector<uint64_t> vect;
#pragma omp parallel 
	{
		std::vector<uint64_t> private_vec;
#pragma omp for nowait schedule(static)
		for (int i = 1000; static_cast<uint64_t>(i) <= 999999999; i++)
		{

			if (check_same_digits(static_cast<uint64_t>(i), static_cast<uint64_t>(i) * n))
			{
				private_vec.push_back(static_cast<uint64_t>(i));
			}
		}
#pragma omp for schedule(static) ordered
		for (int i = 0; i < omp_get_num_threads(); i++) {
#pragma omp ordered
			vect.insert(vect.end(), private_vec.begin(), private_vec.end());
		}
	}

	std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
	std::cout << "Time spent calculating = " << std::chrono::duration_cast<std::chrono::seconds>(end - begin).count() << "[s]" << std::endl;
	uint64_t amount_of_elements = 0;


	printf("There are %d elements, that satisfy the condition of the task.\n", vect.size());

	std::cout << "First 100 (or less) elements are: \n";
	int counter = 0;
	for (uint64_t v : vect)
	{
		counter++;
		if (counter < 101)
		{
			std::cout << "Initial number " << v << " Multiplied number " << v * n << std::endl;
		}

		if (counter > 99)
		{
			break;
		}
	}

}
