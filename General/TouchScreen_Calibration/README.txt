
This is an example project that can be used as a touchscreen 
configuration utility on Linux systems where tslib is being 
used.  The user is prompted to select a series of points and 
the touchscreen calibration is based on the touch points generated.

On Linux systems the application will run and a configuration file
is written to /etc/pointercal

Make sure that the directory /etc/ exists on the target.
Make sure that SBengine is ran with sufficient permissions to create 
and edit files in /etc/

On non-Linux systems the application will run but no configuration
file is generated. 

After the final point is selected, the application terminates.
