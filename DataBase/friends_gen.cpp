#include <iostream>

void generate_relation(int id,int maxxx) {
    std::string exec_psql;
    int f = std::rand()%(maxxx-id)+id+1;
    std::cout << "INSERT INTO simplytrackme.friends values (" << id << "," << f << ");" << std::endl;
}

void generate_friends(int num) {
    for(int i = 0; i < num; i++)
        generate_relation(i,num);
}

int main() {
    srand(time(NULL));
    int n;
    std::cin>>n;
    generate_friends(n);
}