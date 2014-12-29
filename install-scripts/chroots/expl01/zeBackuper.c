/*
    Author: mdube & _eko
    Desc: A binary wrapping tar. Written only to reduce ambiguity on the challenge.
          We strongly suggest you do not try to hack this binary. 
*/
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <dirent.h> 
#include <unistd.h>

int main(int argc, char** argv) {
  int i;
  char * bin = "/bin/tar";
  char * opts = "cvzf";
  char archive[128];
  char files[3][128];
  char cwd[128];
  time_t t;
  struct tm *lt;
  DIR           *d;
  struct dirent *dir;
  
  // Determining current time for backup file
  t = time(NULL);
  lt = localtime(&t);
  strftime(archive, sizeof(archive), "/home/expl01s/bkp-%Y-%m-%d-%H%M%S.tar.gz", lt);
  
  // Defining args
  for(i=0; i<3; ++i) {
    memset(files[i], '\x00', 128);
  }

  // Determine what to backup
  // For security reasons, backup is limited to three files/folders. (lol)
  getcwd(cwd, sizeof(cwd));
  d = opendir(cwd);
  if (d) {
    i=0;
    while ((dir = readdir(d)) != NULL && i < 3) {
      if (dir->d_type == DT_REG){
        printf("%s\n", dir->d_name);
        strncpy(files[i], dir->d_name, 128);
        i++;
      }
    }
    closedir(d);
  }

  // Execute tar
  char * args[] = {bin, opts, archive, files[0], files[1], files[2], NULL};
  args[3+i] = NULL;
  execvp(bin, args);
  return 0;
}
