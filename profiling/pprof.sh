#!/bin/bash

focus='\(\*localVolumeMounter\).SetUpAt'
#go tool pprof -sample_index=samples -focus "$focus" -nodefraction=0 -edgefraction=0 ./kubelet.v1.11.0-alpha.0.1882+7a245922ec4602 cpu2.profile 
go tool pprof -sample_index=samples -focus "$focus" -nodefraction=0 -edgefraction=0 ./kubelet.v1.11.0-alpha.0.1878+acd435c57853ad cpu1.profile
