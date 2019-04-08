# Part II. Intro to Functions.
# April 8, 2019

# Fahrenheit to Kelvin
far_to_kel <- function(temp) { 
  kel <- ((temp-32)*(5/9)) + 273.15  
  return(kel)                  
}
far_to_kelvin(0)

# Convert Kelvin to Celsius
kel_to_cel <- function(temp) {
  cel <- temp - 273.15
  return(cel)
}
kel_to_cel(0)

# F to C using 2 functions just wrote
far_to_cel <- function(temp) {
  far <- kel_to_cel(far_to_kel(temp))
  return(Fah)
}
Fah_to_C(212)
Fah_to_C(32)
