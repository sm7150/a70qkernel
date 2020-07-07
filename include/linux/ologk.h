#ifndef _OLOG_KERNEL_H_
#define _OLOG_KERNEL_H_

#include <linux/unistd.h>

#define OLOG_CPU_FREQ_FILTER   1500000

#define ologk(...)
#define perflog(...)

#define ologk(...) perflog(PERFLOG_UNKNOWN, __VA_ARGS__)
extern void perflog(int type, const char *fmt, ...);

#endif
