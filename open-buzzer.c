/* 
 * open-buzzer.c
 *
 * Raspberry Pi GPIO example using sysfs interface.
 * Guillermo A. Amaral B. <g@maral.me>
 *
 * Modifications by Alex Hioreanu.
 *
 * NOTE: this is meant to run as root.  To the buzzer on the
 * Raspberry Pi, we compile a version and set it setuid-root
 * in /usr/local/share/sbin/open-buzzer.
 */

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PIN 2

#define BUFFER_MAX 30

static int GPIOExport(int pin)
{
  char buffer[BUFFER_MAX];
  ssize_t bytes_written;
  int fd;

  fd = open("/sys/class/gpio/export", O_WRONLY);
  if (-1 == fd) {
    fprintf(stderr, "Failed to open export for writing.\n");
    return -1;
  }

  bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pin);
  write(fd, buffer, bytes_written);
  close(fd);
  return 0;
}

static int GPIOUnexport(int pin)
{
  char buffer[BUFFER_MAX];
  ssize_t bytes_written;
  int fd;

  fd = open("/sys/class/gpio/unexport", O_WRONLY);
  if (-1 == fd) {
    fprintf(stderr, "Failed to open unexport for writing.\n");
    return -1;
  }

  bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pin);
  write(fd, buffer, bytes_written);
  close(fd);
  return 0;
}

typedef enum { IN = 0, OUT = 1 } pin_direction;

static int GPIODirection(int pin, pin_direction new_direction)
{
  char path[BUFFER_MAX];
  int fd;

  snprintf(path, BUFFER_MAX, "/sys/class/gpio/gpio%d/direction", pin);
  fd = open(path, O_WRONLY);
  if (-1 == fd) {
    fprintf(stderr, "Failed to open gpio direction for writing.\n");
    return -1;
  }

  char *dir_s = (new_direction == IN ? "in" : "out");
  if (-1 == write(fd, dir_s, strlen(dir_s))) {
    fprintf(stderr, "Failed to set direction.\n");
    close(fd);
    return -1;
  }

  close(fd);
  return 0;
}

static int GPIORead(int pin)
{
  char path[BUFFER_MAX];
  char value_str[3];
  int fd;

  snprintf(path, BUFFER_MAX, "/sys/class/gpio/gpio%d/value", pin);
  fd = open(path, O_RDONLY);
  if (-1 == fd) {
    fprintf(stderr, "Failed to open gpio value for reading.\n");
    return -1;
  }

  if (-1 == read(fd, value_str, 3)) {
    fprintf(stderr, "Failed to read value.\n");
    return -1;
  }

  close(fd);

  return atoi(value_str);
}

typedef enum { LOW = 0, HIGH = 1 } pin_state;

static int GPIOWrite(int pin, pin_state new_state)
{
  char path[BUFFER_MAX];
  int fd;

  snprintf(path, BUFFER_MAX, "/sys/class/gpio/gpio%d/value", pin);
  fd = open(path, O_WRONLY);
  if (-1 == fd) {
    fprintf(stderr, "Failed to open gpio value for writing.\n");
    return -1;
  }

  if (1 != write(fd, (new_state == LOW ? "0" : "1"), 1)) {
    fprintf(stderr, "Failed to write value.\n");
    return -1;
  }

  close(fd);
  return 0;
}

int main(int argc, char *argv[])
{
  double on_seconds = 5.0;
  if (argc > 1) {
    if (sscanf(argv[1], "%lf", &on_seconds) != 1 || on_seconds < 0.1 || on_seconds > 60) {
      printf("usage: %s [seconds]\n", argv[0]);
      printf("Opens the door for a few seconds.\n"
             "The optional [seconds] parameter specifies how long to keep\n"
             "the door open (and may be fractional).  The default value is\n"
             "five seconds.\n");
      return 1;
    }
  }

  if (GPIOExport(2) < 0) {
    fprintf(stderr, "Could not export pin 2.\n");
    return 1;
  }

  if (GPIODirection(2, OUT) < 0) {
    fprintf(stderr, "Could not set pin 2 to output.\n");
    return 2;
  }

  if (GPIOWrite(2, LOW) < 0) {
    fprintf(stderr, "Could not set pin 2 to low.\n");
    return 2;
  }

  usleep(on_seconds * 1000000);

  if (GPIOWrite(2, HIGH) < 0) {
    fprintf(stderr, "Could not set pin 2 to high.\n");
    return 3;
  }

  if (GPIOUnexport(2) < 0) {
    fprintf(stderr, "Could not unexport pin 2.\n");
    return 4;
  }

  return 0;
}
