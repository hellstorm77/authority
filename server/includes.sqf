#define this_script __FILE__
#define __tky_debug diag_log format ["***tky debug: %1 @ %2, fps = %3 & minfps =  %4", (__FILE__ select [(21 + (count worldName)), ((count __FILE__) - 4)]) , __LINE__, diag_fps, diag_fpsmin];
#define __tky_starts diag_log format ["***%1 starts, %2,%3,%4,%5", (__FILE__ select [(21 + (count worldName)), ((count __FILE__) - 4)]), diag_tickTime, time, diag_fps, diag_fpsmin ];
#define __tky_ends diag_log format ["***%1 ends, %2,%3,%4,%5", (__FILE__ select [(21 + (count worldName)), ((count __FILE__) - 4)]), diag_tickTime, time, diag_fps, diag_fpsmin ];