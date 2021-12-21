#define MEM_SCRATCH_PAD  ((volatile int *) (0x00400f00))

int  gcd(int a, int b);
int  fibonacci(unsigned n);
void swap(int *xp, int *yp);
void bubbleSort(int arr[], int n);

int main() {
    int arr[] = {60,70,80,90,100,200,300};
    bubbleSort(arr,7);
    for(int i=0;i<7;i++){
        MEM_SCRATCH_PAD[i] = arr[i];
    }
    MEM_SCRATCH_PAD[8] = fibonacci(9);
    MEM_SCRATCH_PAD[9] = gcd(24,16);
    return 0;
}

int gcd(int a, int b){
    return 0;
}
int fibonacci(unsigned n){
    if (n == 0)  return 1;
    if (n == 1)  return 1;
    return fibonacci(n-1) + fibonacci(n-2);
}
void swap(int *xp, int *yp) {
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}
void bubbleSort(int arr[], int n) {
    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
}
