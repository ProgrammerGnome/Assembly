#include <stdio.h>

extern int my_variable;  // a NASM-ben definiált változó importálása
extern int for_2();

int main() {
    my_variable = 20;   // az érték módosítása
    for_2();
    printf("\n");
    return 0;
}
