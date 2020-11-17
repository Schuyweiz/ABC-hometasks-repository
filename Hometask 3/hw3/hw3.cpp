

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

void run(std::vector<uint64_t>& vect, uint64_t start, uint64_t end, int mult)
{
	for (uint64_t i = start; i < end; i++)
	{
		if (check_same_digits(i, static_cast<uint64_t>(mult) * i))
		{
			vect.push_back(i);
		}
	}
}


int main()
{
	int n;
	int threads_amt;

	printf("Enter the multiplication factor: ");
	std::cin >> n;
	printf("Enter the amount of threads to imply: ");
	std::cin >> threads_amt;
	while (n < 1 || n > 10 || threads_amt<1)
	{
		printf("Wrong values. 1<n<10 and amount of threads involved must be positive.\n");
		printf("Enter the multiplication factor: ");
		std::cin >> n;
		printf("Enter the amount of threads to imply: ");
		std::cin >> threads_amt;
	}
	int step = (999999999 - 1000) / threads_amt;
	int remainder = (999999999 - 1000) % threads_amt;
	std::vector<std::thread> threads;
	std::vector<std::vector<uint64_t>> vectors(threads_amt);

	for (uint64_t i = 0; i < threads_amt - 1; i++)
	{
		threads.emplace_back(run,

			std::ref(vectors[i]), static_cast<uint64_t>(i * step + 1000), static_cast<uint64_t>((1 + i) * step + 1000), n);
	}
	threads.emplace_back(run,
		std::ref(vectors[threads_amt - 1]),
		static_cast<uint64_t>((threads_amt - 1) * step + 1000),
		static_cast<uint64_t>(threads_amt * step + 1 + remainder + 1000),
		n);
	std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
	for (int i = 0; i < threads_amt; i++)
	{
		threads[i].join();
	}

	std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
	std::cout << "Time spent calculating = " << std::chrono::duration_cast<std::chrono::seconds>(end - begin).count() << "[s]" << std::endl;
	uint64_t amount_of_elements = 0;
	for (std::vector<uint64_t> v : vectors)
	{
		amount_of_elements += v.size();
	}

	printf("There are %d elements, that satisfy the condition of the task.\n", amount_of_elements);

	std::cout << "First 100 (or less) elements are: \n";
	int counter = 0;
	for (std::vector<uint64_t> v : vectors)
	{
		for (uint64_t num : v)
		{
			
			counter++;
			if (counter < 101)
			{
				std::cout << num << std::endl;
			}
		}
		if (counter > 99)
		{
			break;
		}
	}

}
