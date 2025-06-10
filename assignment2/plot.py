# !/usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

# parameters to modify
filename="iperf3_lost.log"
label='iperf3 lost'
xlabel = 'bandwidth'
ylabel = 'lost'
title='iperf3 lost at different bandwidth'
fig_name='iperf3_lost.png'
bins=1000 #adjust the number of bins to your plot


t = np.loadtxt(filename, delimiter=" ", dtype="str")

plt.plot(t[:,0], t[:,1], label=label)  # Plot some data on the (implicit) axes.
#Comment the line above and uncomment the line below to plot a CDF
#plt.hist(t[:,1], bins, density=True, histtype='step', cumulative=True, label=label)
plt.xlabel(xlabel)
plt.ylabel(ylabel)
plt.title(title)
plt.legend()
plt.savefig(fig_name)
plt.show()
