'''
********************************************************
* 	Presentadores:Rubén Alexis Núñez Montaña && 
		      Jonathan Alexander Torres Benitez
* 	Profesor: John Jairo Corredor, PhD
* 	Computación Paralela y Distribuida
* 	Universidad Sergio Arboleda
********************************************************
'''
#from distutils.core import setup, Extension
#from Cython.Build import cythonize


#setup(ext_modules=exts)
from distutils.core import setup
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from distutils.extension import Extension
import numpy 

#exts = (cythonize('heat.pyx'))
exts=(cythonize('Cy_heat.pyx'))
setup(name = 'heat', cmdclass={"build_ext": build_ext},
  ext_modules=exts, 
  include_dirs=[numpy.get_include()])
