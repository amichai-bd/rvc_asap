#define _ASMLANGUAGE
#define MEM_SCRATCH_PAD  ((volatile int *) (0x00001000))

int  gcd(int a, int b); // work
static int  fibonacci(unsigned n); // work
void swap(int *xp, int *yp); // work
void bubbleSort(int arr[], int n); // work

int main() 
{
    int arr[] = {80,200,60,300,100,70,90};

    bubbleSort(arr,7); // bubble sort works well

    for(int i=0;i<7;i++)
        MEM_SCRATCH_PAD[i] = arr[i];

    MEM_SCRATCH_PAD[7] = fibonacci(9); // fibonacci works well
    MEM_SCRATCH_PAD[8] = gcd(24,16); // gcd works well
    
    return 0;
}

int gcd(int a, int b)
{
    if (b != 0)
        return gcd(b, a % b);
    else
        return a;
}

static int fibonacci(unsigned n)
{
     if (n <= 1)
       return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

void swap(int *xp, int *yp) 
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

void bubbleSort(int arr[], int n) 
{
    int i, j;
    for (i = 0; i < n-1; i++)    
        for (j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
}