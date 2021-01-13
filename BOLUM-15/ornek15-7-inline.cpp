#include <stdio.h>
const int n = 10;
int main(){
	int dizi[n], i;
	for (i = 0; i < n; i++){
		dizi[i] = i + 1;
		printf("%8x, ", dizi[i]);
	}
	printf("\n\n");
	__asm {
		MOV ECX, n
		XOR ESI, ESI
	L2:	MOV EAX, dizi[ESI]
		PUSH ECX
		MOV ECX, 32
	L1: 	SHR EAX, 1
		RCL EBX, 1
		LOOP L1
		POP ECX
		MOV dizi[ESI], EBX
		ADD ESI, 4
		LOOP L2
	}
	for (i = 0; i < n; i++)
		printf("%8x, ", dizi[i]);
	return 0;
}
