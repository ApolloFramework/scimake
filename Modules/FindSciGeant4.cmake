message("Looking for Geant4.")

set(SUPRA_SEARCH_PATH ${SUPRA_SEARCH_PATH})

#set(instdirs geant4-ser)

set(Geant4_LIBRARY_LIST
  G4interfaces
  G4FR
  G4materials
  G4GMocren
  G4modeling
  G4OpenGL
  G4parmodels
  G4RayTracer
  G4particles
  G4Tree
  G4persistency
  G4VRML
  G4physicslists
  G4analysis
  G4processes
  G4clhep
  G4readout
  G4digits_hits
  G4run
  G4error_propagation
  G4track
  G4event
  G4tracking
  G4geometry
  G4visHepRep
  G4gl2ps
  G4visXXX
  G4global
  G4vis_management
  G4graphics_reps
  G4zlib
)

SciFindPackage(
  PACKAGE "Geant4"
  HEADERS "globals.hh"
  INCLUDE_SUBDIRS include/Geant4
  LIBRARIES ${Geant4_LIBRARY_LIST}
)

if (GEANT4_FOUND)
  message(STATUS "Found Geant4")
else ()
  message(STATUS "Did not find Geant4.  Use -DGeant4_ROOT_DIR to specify the installation directory.")
endif ()

