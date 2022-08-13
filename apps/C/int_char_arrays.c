#define _ASMLANGUAGE
#include "../defines/rvc_defines.h"
#include <string.h>

#define SIZE 40

char * rvc_strtok(char * string, const char * delim) {
  /* Static storage class is used to keep 
   track of the string's index in each function call */
  static char * index;

  // Initial case, where user passes the actual string in strtok
  if (string != NULL) {
    index = string;
  } else {
    // further cases, where NULL is passed
    string = index;
  }

  // Final case where the index will be '\0'
  if ( * index == '\0') {
    return NULL;
  }

  while ( * index != '\0') {
    // Iterate over each delimeter and check if any delimiter matches to the character
    for (int i = 0; delim[i] != '\0'; i++) {
      if ( * index == delim[i]) {

        // We are not intrested in the following case where there is 
        // no character available to print before delimiter.
        // This case occurs when two delimiters are side by side.
        if (index == string) {
          index++;
          string++;
        } else {
          * index = '\0';
          break;
        }
      }
    }

    // return the token
    if ( * index == '\0') {
      index++;
      return string;
    }

    index++;
  }
  return string;

}

char *rvc_strcat(char *s1, const char *s2)
{
    //Pointer should not null pointer
    if((s1 == NULL) && (s2 == NULL))
        return NULL;
    //Create copy of s1
    char *start = s1;
    //Find the end of the destination string
    while(*start != '\0')
    {
        start++;
    }
    //Now append the source string characters
    //until not get null character of s2
    while(*s2 != '\0')
    {
        *start++ = *s2++;
    }
    //Append null character in the last
    *start = '\0';
    return s1;
}


int main()
{
  volatile int *ptr = (int*) D_MEM_BASE;

  int a = 0x73;
  char c = (char) a;
  ptr[0] = c;

  char dest[SIZE] = "gil";
  char src[] = "yaakov";

	int result = strcmp(dest, src); // Work, amazing!
  ptr[1] = result;

  rvc_strcat(dest, src);

  int size = ((sizeof(dest) + sizeof(src)) - 1);
  for(int i = 0 ; i < size ; i++){
      ptr[i+2] = dest[i];
  }

  // Declare a character array and initialize it with the input string.
  char string[] = "gil;gil";
  
  // String delimiter - To split the string
  const char * delimiter = ";";
  
  char * returnS = rvc_strtok(string, delimiter); // don't work for right now
  for(int i = 0 ; i < 7 ; i++){
      ptr[i+12] = returnS[i];
  }

  return 0;
}