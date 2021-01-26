# SlurmGPULogBoilerplate
A simple boilerplate layout for logging GPU usage via nvidia-smi for a slurm job.

# What to change

What you need to change:

- The SBATCH at the beginning of the file
- The path of the log file in the beginning (LOGMAINDIR, LOGDIR and LOGPATH)
- The CHANGEMEHERE string to the program that you want to start
