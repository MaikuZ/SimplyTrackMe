#include <iostream>
#include <vector>
#include <set>

#define NUM_OF_GROUPS 100

void single_group_member(int id) {
    std::set<int> temp;
    int num = rand()%5;
    for(int i = 0 ; i < num; i++) {
        temp.insert(rand()%NUM_OF_GROUPS+1);
    }
    std::string exec_psql;
    for(int idx : temp) {
        exec_psql = "INSERT INTO simplytrackme.group_members values ("
                    + std::to_string(id) + ',' + std::to_string(idx) + ");";
        std::cout << exec_psql << std::endl;
    };
}

void generate_group_members(int size) {
    for (int i = 0; i < size; i++) {
        single_group_member(i);
    }
}

int main() {
    srand(time(NULL));
    int nummber;
    std::cin >> nummber;
    generate_group_members(nummber);
}

