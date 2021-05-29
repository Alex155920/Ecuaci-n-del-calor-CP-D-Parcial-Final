'''
********************************************************
* 	Presentadores:Rubén Alexis Núñez Montaña && 
		      Jonathan Alexander Torres Benitez
* 	Profesor: John Jairo Corredor, PhD
* 	Computación Paralela y Distribuida
* 	Universidad Sergio Arboleda
********************************************************
'''

#cython: language_level=3
import matplotlib

#matplotlib.use('Agg')
#import matplotlib.pyplot as plt
import numpy as np
cimport numpy as np 
import cython


# Set the colormap
#plt.rcParams['image.cmap'] = 'BrBG'
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.cdivision(True)

cdef evolve(np.ndarray[np.float_t, ndim=2] u, 
            np.ndarray[np.float_t, ndim=2] u_previous,		
            float a, float dt, float dx2, float dy2):
    """Explicit time evolution.
       u:            new temperature field
       u_previous:   previous field
       a:            diffusion constant
       dt:           time step. """

    #cdef int n = u.shape[0] #len(u.T)
    #cdef int m = u.shape[1]
    
    cdef int n,m = len(u)
    

    cdef int i,j


    cdef float inver_dx_2 = 1. / dx2
    cdef float inver_dy_2 = 1. / dy2

    for i in range(1, n-1):
        for j in range(1, m-1):
            u[i, j] = u_previous[i, j] + a * dt * ( \
             (u_previous[i+1, j] - 2*u_previous[i, j] + \
              u_previous[i-1, j]) * inver_dx_2 + \
             (u_previous[i, j+1] - 2*u_previous[i, j] + \
                 u_previous[i, j-1]) * inver_dy_2 )
    u_previous[:] = u[:]
    
    #contador+=1
    #print("Prueba Cython: ", u_previous.shape, contador)
def iterate(field, field0, a, dx, dy, timesteps, image_interval):
    """Run fixed number of time steps of heat equation"""

    dx2 = dx**2
    dy2 = dy**2
    
    

    # For stability, this is the largest interval possible
    # for the size of the time-step:
    dt = dx2*dy2 / ( 2*a*(dx2+dy2) )    

    for m in range(1, timesteps+1):
        evolve(field, field0, a, dt, dx2, dy2)
        #if m % image_interval == 0:
            #write_field(field, m)

def init_fields(filename):
    # Read the initial temperature field from file
    field = np.loadtxt(filename)
    field0 = field.copy() # Array for field of previous time step
    return field, field0

#def write_field(field, step):
    #plt.gca().clear()
    #plt.imshow(field)
    #plt.axis('off')
    #plt.savefig('heat_{0:03d}.png'.format(step))
