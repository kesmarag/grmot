# GRMOT - strong GRound MOTion simulations
![img](./images/grmot_logo.png)

Warning : the documentation of the library is still under preparation.

When using this code, please cite the following arxiv manuscript
- manuscript link is to be added

## General description
GRMOT generates simulated seismograms (displacement, velocity, acceleration) using the 3D discrete wavenumber
representation method. The code runs in parallel.
The library's core has been written in the Rust programming language and provides a convenient python user interface.

## Installation
The library supports the GNU/Linux operating system.

### python 3.6
pip install https://github.com/kesmarag/grmot/raw/main/target/wheels/grmot-0.9.0-cp36-cp36m-manylinux_2_5_x86_64.manylinux1_x86_64.whl

### python 3.7
pip install https://github.com/kesmarag/grmot/raw/main/target/wheels/grmot-0.9.0-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl

### python 3.8
pip install https://github.com/kesmarag/grmot/raw/main/target/wheels/grmot-0.9.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.whl

### python 3.9
pip install https://github.com/kesmarag/grmot/raw/main/target/wheels/grmot-0.9.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl

### python 3.10
pip install https://github.com/kesmarag/grmot/raw/main/target/wheels/grmot-0.9.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.whl

## Using GRMOT
First, we create a reference sub-plane. The following parameters determine this sub-plane

- The top centre point of the fault (north ((x_0) in km), east ((y_0) in km), and depth ((z_0) in km)) with respect to a general reference point.
- The dip, strike and rake angles.

![img](./images/img1_grmot.png)

We then create a number of subfaults (see the rectangle ABCD) providing the following.

-   Center of the subfault relative to the reference fault point (in km).
-   Length and width of the subfault (km).
-   Rupture velocity and the orientation of the rupture front.
-   A piecewise linear rupture time function.

![img](./images/rupture.png)

The library provides three environmental setups as it is shown in the following image. In parenteses given the density, velocities of p- and s-waves and thickness for each medium.
![img](./images/img3_grmot.png)

I. A halfspace

Create a python tupple as follows:
```python
medium = ((rho_1, alpha_1, beta_1, 0)) # with 0 we mean halfspace (infinity thinkness)
```


II. A layer over a halfspace

```python
medium = ((rho_1, alpha_1, beta_1, h_1),
          (rho_2, alpha_2, beta_2, 0)) 
```

III. Two layers over a halfspace


```python
medium = ((rho_1, alpha_1, beta_1, h_1),
          (rho_2, alpha_2, beta_2, h_2),
          (rho_3, alpha_3, beta_3, 0)) 
```

Following a simple but full working test case

```python
from grmot import Fault
import numpy as np
import matplotlib.pyplot as plt

medium = ((2., 5.7*0.5, 3.2*0.5, 0.03),(2.8, 5.7, 3.2, 0.0),) 
loc = (0.0,0.0,1.0) # (x_fault,y_fault,z_fault)
angles = (55*np.pi/180., 195*np.pi/180., -90.*np.pi/180.) # (dip,strike,rake)
fpars = (1/8, 5.0) # (df [Hz], f_max [Hz])
conf = (400, 400, 80, 80, 1.0) # (nx_max, ny_max, Lx, Ly)
fault = Fault(angles,loc,fpars,medium,conf)

# list of subfaults
subfaults = [((1.0, 1.0, 0.0, 0.0, 2.0, 0.0), # (length across the strike, length across the dip, ξ, η, v_r, θ)
          [(0.0, 0.0), (0.1, 1.0)])] # list of rupture points (time, slip (in m))

# list of receivers
receivers = [(0.0,10.0)] # (east,west) in km

n = 2048 # number of samples
dn,de,dv,vn,ve,vv,an,ae,av = fault.simulate(subfaults, receivers, n)

plt.figure(figsize=(10,4))
t = np.linspace(0,8,2048)
plt.grid()
plt.plot(t,dv[0])
plt.ylabel('vertical displacement [m]')
plt.xlabel('time [s]')
plt.show()
```

![img](./images/img2_grmot.png)

The library contains several help functions that are not yet documented. Please look at the source code that includes these functions. 

https://github.com/kesmarag/grmot/blob/main/grmot/utils.py


## License
GRMOT is distributed as free software (GPL-v3) in the hope that it will useful, but without any warranty.

## Acknowledgements
I would like to acknowledge Professor Apostolos Papageorgiou for his guidance and valuable advice. 

## References

