#include <stdio.h>
extern int Topla(int *, int);
int main(){
	int i, top, n;
	printf("Kaca kadar sayilari toplamak istiyorsunuz: ");	
	scanf("%d", &n);
	int dizi[n];
	for(i = 0; i < n; i++)
		dizi[i] = i + 1;
	top = Topla(dizi, n);
	printf("Toplam: %d\n", top);
	return 0;
}
