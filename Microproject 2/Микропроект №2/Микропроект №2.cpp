// Микропроект №2.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <thread>
#include <pthread.h>
#include <queue>
#include <string>
#include <stdlib.h>
#include <time.h>


void settle(char person);
bool is_available();

pthread_mutex_t mutex;

int8_t singleRoom[10] = { 0 };
int8_t doubleRoom1[15] = { 0 };
int8_t doubleRoom2[15] = { 0 };

void settle_single(char person, int8_t room);
int8_t single_is_free();
void settle_double(char person, int8_t room);
int8_t double_is_free(char person);

//tries to settle a person and displays a message reflecting the result.
void settle(char name, int num)
{
	int8_t room = single_is_free();
	//if room is not -1, then there is a free room at the hotel
	if (room > -1)
	{
		settle_single(name, room);
		std::cout << std::to_string(num) + " Settled\n";
		return;
	}
	room = double_is_free(name);
	if (room > -1)
	{
		settle_double(name, room);
		std::cout << std::to_string(num) + " Settled\n";
		return;
	}
	std::cout << std::to_string(num) + "Failed to settle\n";

}

bool is_available()
{
	//locking critical section
	pthread_mutex_lock(&mutex);
	for (int8_t room : singleRoom)
	{
		if (room == 0)
		{
			pthread_mutex_unlock(&mutex);
			return true;
		}
	}
	for (auto i = 0; i < 15; i++)
	{
		if (doubleRoom1[i] == 0 || doubleRoom2[i] == 0)
		{
			pthread_mutex_unlock(&mutex);
			return true;
		}
	}
	pthread_mutex_unlock(&mutex);

	return false;
}

void settle_single(char person, int8_t room)
{
	singleRoom[room] = person;
}

int8_t single_is_free()
{
	//checking every room for free space.
	for (int i = 0; i < 10; i++)
	{
		if (singleRoom[i] == 0)
		{
			return i;
		}
	}
	return -1;
}

void settle_double(char person, int8_t room)
{
	if (doubleRoom1[room] == 0)
	{
		doubleRoom1[room] = person;
	}
	else
	{
		doubleRoom2[room] = person;
	}
}

int8_t double_is_free(char person)
{
	for (int i = 0; i < 15; i++)
	{
		if (doubleRoom1[i] == 0)
		{
			return i;
		}
		else if (doubleRoom2[i] == 0 && doubleRoom1[i] == person)
		{
			return i;
		}
	}
	return -1;

}


class Client
{
public:
	char sex;
	int name;
	Client(char sex, int name)
	{
		this->sex = sex;
		this->name = name;
	}

	std::string to_string()
	{
		return "Client number " + std::to_string(name) + (char)sex;
	}
};

std::deque<Client> clients;


void create_clients()
{
	int count = 1;
	while (is_available())
	{
		//generating a random number based on the amount of ticks.
		auto t = clock();
		srand(t);
		char person = std::rand() % 2 == 0 ? 'M' : 'F';
		pthread_mutex_lock(&mutex);

		Client client(person, count);
		clients.emplace_back(client);
		count++;
		std::cout << client.to_string() + " has arrived." << std::endl;
		pthread_mutex_unlock(&mutex);
	}
}

void try_settle()
{
	while (is_available())
	{
		if (!clients.empty())
		{
			pthread_mutex_lock(&mutex);
			//taking first person from the queue and deleting him/her from the deque.
			Client cl = clients.front();
			clients.pop_front();
			settle(cl.sex, cl.name);
			pthread_mutex_unlock(&mutex);
		}
	}
}

void display_hotel_rooms()
{
	std::cout << "Single rooms: \n";
	for (int8_t room : singleRoom)
	{
		std::cout << static_cast<char>(room) << " ";
	}

	std::cout << "\nDouble rooms:\n";
	for (int8_t room : doubleRoom1)
	{
		std::cout << static_cast<char>(room) << " ";
	}
	std::cout << "\n";
	for (int8_t room : doubleRoom2)
	{
		std::cout << static_cast<char>(room) << " ";
	}
}

int main()
{

	pthread_mutex_init(&mutex, NULL);
	std::thread clients_generator(create_clients);
	std::thread portier(try_settle);
	portier.join();
	clients_generator.join();

	for (Client client : clients)
	{
		std::cout << client.to_string() + " Failed to settle" << std::endl;
	}

	display_hotel_rooms();
}

