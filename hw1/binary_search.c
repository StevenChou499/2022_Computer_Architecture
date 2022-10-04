#include <stdio.h>

int array[6] = {-1, 0, 3, 5, 9, 12};
int length = 6;

int search(int* nums, int numsSize, int target)
{
    int left = 0, right = numsSize - 1;
    while (left <= right)
    {
        int middle = left + (right - left) / 2;
        
        if (nums[middle] == target)
            return middle;
        
        else if (nums[middle] < target)
            left = middle + 1;
        
        else
            right = middle - 1;
    }
    return -1;
}

int main(void)
{
    int index = search(array, length, 9);
    printf("All array elements :");
    for (int i = 0; i < length; i++) {
        printf("%d  ", array[i]);
    }
    printf("\n");
    printf("For number %d, the position is: %d\n", 9, index);
    return 0;
}