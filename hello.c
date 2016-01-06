#include <stdio.h>

void print_bar(void);
void print_bar2(void);
void print_test1(void);
void print_test2(void);

int main(void) {
    printf("Hello World\n");
    printf("Welcome Cho-Dev on github\n");
    printf("add 1\n");
    printf("add 2\n");
    print_bar();
    print_bar2();
    printf("end of message\n");
    {
        int i;
        for (i = 0; i < 12; i++) {
            printf("%d", i);
        }
        printf("\n");
    }
    print_bar();
    print_test1();
    print_test2();
    return 0;
}

