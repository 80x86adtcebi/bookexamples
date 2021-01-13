#include <stdio.h>

extern "C" void SelSortASM(int *, int);
void SelSortC(int *, int);

const int n = 100000;

int main(){
	int dizi[n], i;
	for (i = 0; i < n; i++)
		dizi[i] = i + 1;
	SelSortASM(dizi, c);
	//SelSortC(dizi, c);
	printf("Dizinin ilk elemani: %d, son elemani: %d\n", dizi[0], dizi[n - 1]);
	return 0;
}

void SelSortC(int *sdizi, int n) {
	int i, j, tmp, max;
	for (i = 0; i < n - 1; i++) {
		max = i;
		for (j = i + 1; j < n; j++)
			if (sdizi[j] > sdizi[max])
				max = j;
		tmp = sdizi[max];
		sdizi[max] = sdizi[i];
		sdizi[i] = tmp;
	}
}
