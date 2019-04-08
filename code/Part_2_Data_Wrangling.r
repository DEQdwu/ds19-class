# Part II. Intro to Functions.
# April 8, 2019

# Fahrenheit to Kelvin
far_to_kel <- function(temp) { 
  kel <- ((temp-32)*(5/9)) + 273.15  
}
far_to_kel(0)

# Convert Kelvin to Celsius
kel_to_cel <- function(temp) { 
  cel <- temp - 273.15
  return(cel)
}
kel_to_cel(273.15)

# F to C using 2 functions just wrote
far_to_cel <- function(temp) {
  far <- kel_to_cel(far_to_kel(temp))
  return(far)
}
far_to_cel(212)
far_to_cel(32)

# Convert Kelvin to Celsius; add if(is.numeric(temp)) function to check for number input
kel_to_cel2 <- function(temp) { 
  if(!is.numeric(temp)) {
    stop("temp not numeric")
    }
  cel <- temp - 273.15
  return(cel)
}
kel_to_cel2(2)
kel_to_cel2(100)

