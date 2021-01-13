#include <stdio.h>
extern "C" void SelSortASM(int *, int);
const int n = 100000;
int main(){
	int dizi[n], i;
	for (i = 0; i < n; i++)
		dizi[i] = i + 1;
	SelSortASM(dizi, c);
	printf("Dizinin ilk elemani: %d, son elemani: %d\n", dizi[0], dizi[n - 1]);
	return 0;
}
