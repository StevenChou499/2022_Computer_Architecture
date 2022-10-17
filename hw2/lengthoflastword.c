#include <stdio.h>

int lengthOfLastWord(char *s){
	int i = 0;
	char *head = s;
    while (*s) {
        s++;
        i++;
    }
	s = head;
	int length = 0;
	s = s + i - 1;
	
	while(*s == ' '){
	s--;
	}

	while(*s != ' ' && i--){
	s--;
	length++;
	}

	return length;
}

int main()
{
	char *str1 = "Hello World";
	char *str2 = "I am a student  ";
	char *str3 = "a";
	int len1 = lengthOfLastWord(str1);
	int len2 = lengthOfLastWord(str2);
	int len3 = lengthOfLastWord(str3);
	printf("For string \"%s\", Length of last word : %d\n", str1, len1);
	printf("For string \"%s\", Length of last word : %d\n", str2, len2);
	printf("For string \"%s\", Length of last word : %d\n", str3, len3);
	
	return 0;
}