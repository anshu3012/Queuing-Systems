# Queuing-Systems

I wrote a Monte Carlo simulation for M/M/1 queuing system since it's deterministic.
Now I tried modifying the same code for a G/G/1 queueing system with interarrival times and service times having a triangular distribution. Instead of drawing samples from Poisson and exponential distribution, I am drawing samples from the triangular distribution (for G/G/1). However, I am getting results that are hard to make sense of. The analytical approximation results say that the mean waiting time in the queue is  0.9708 which is kinda off from the result (~0.75) I am getting with the simulation.
