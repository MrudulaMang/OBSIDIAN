Both cpu and memory limits are applied by kubelet(and container runtime) and are ultimately enforced by kernel. on linux nodes, the linux kernel enforces limits with cgroups. the behaviour of cpu and memory  limit enforcement is slightly different.

cpu limits are enfored by cpu throttling. whena container approaches its cpu limits, the kernel will restrict access to the cpu cprresponding contianer limit. thus a cpu limit is hard limit the kernel enforces. containers may not use more cpu than is specified in thier cpu limit.

limits are enforced by the kernel with out of memory (oom) kills. whena container uses more tham its memory limit, the kermel may terminate it. 