"""
__author__ = 'Xinyue'
Source : https://stackoverflow.com/questions/39968941/how-to-pack-spheres-in-python
"""

from cvxpy import *
import numpy as np
import matplotlib.pyplot as plt
import dccp

n = 10
r = np.linspace(1,5,n)

c = Variable((n,2))
constr = []
for i in range(n-1):
    for j in range(i+1,n):
        constr.append(norm(c[i,:]-c[j,:])>=r[i]+r[j])
prob = Problem(Minimize(max(max(abs(c),axis=1)+r)), constr)
#prob = Problem(Minimize(max(normInf(c,axis=1)+r)), constr)
prob.solve(method = 'dccp', ccp_times = 1)

l = max(max(abs(c),axis=1)+r).value*2
pi = np.pi
ratio = pi*sum(square(r)).value/square(l).value
print "ratio =", ratio
print prob.status

# plot
plt.figure(figsize=(5,5))
circ = np.linspace(0,2*pi)
x_border = [-l/2, l/2, l/2, -l/2, -l/2]
y_border = [-l/2, -l/2, l/2, l/2, -l/2]
for i in range(n):
    plt.plot(c[i,0].value+r[i]*np.cos(circ),c[i,1].value+r[i]*np.sin(circ),'b')
plt.plot(x_border,y_border,'g')
plt.axes().set_aspect('equal')
plt.xlim([-l/2,l/2])
plt.ylim([-l/2,l/2])
plt.show()
