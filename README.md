# Dust at L2 Simulator

Part of [Vanderbei's Java Simulations](https://github.com/pubino/vanderbei-apps) collection.

A Java-based N-body gravitational simulator by Professor Robert Vanderbei, Princeton University, for dust particle dynamics near the Sun-Earth L2 Lagrange point. This simulation models how dust particles behave in the gravitationally perturbed environment of the outer Solar System.

## Overview

This simulation models:
- Sun, Earth, and other planets as gravitational sources
- Large populations of dust particles (up to thousands)
- Dynamics near the Sun-Earth L2 Lagrange point
- Protoplanetary disk face-on and edge-on views
- Variable viewing orientations

## Running the Application

### Prerequisites

- Java 11 or later (tested with Java 25)

### Quick Start

From the `dustatl2-sim` directory:

```bash
# Build and run
make run

# Or build the macOS app and double-click it
make app
open dist/DustAtL2Simulator.app
```

### Usage

1. Select a scenario from the **Instance** dropdown:
   - **Dusty Inner Solar System**: Solar System with dust particles
   - **Dusty Solar System**: Extended Solar System view
   - **Dust Disk Face-On**: Protoplanetary disk viewed from above

2. Adjust parameters:
   - **dt**: Time step for numerical integration
   - **warp**: Speed multiplier (steps per display update)
   - **n**: Number of dust particles
   - **center on**: Body index to center the view
   - **Orientation**: Viewing angle in degrees

3. Click **Start** to begin the animation
4. Use **Pause/Play** to control the simulation
5. Use **+/-** buttons to zoom in/out
6. Toggle **Show/Hide Trails** to see orbital paths
7. Toggle **Accrete** to enable/disable dust accretion

### Numerical Integrators

- **Midpoint (Leapfrog)**: Symplectic integrator (default)
- **Hermite**: Higher-order predictor-corrector method

## Development

### Project Structure

```
dustatl2-sim/
├── astro/galaxy/
│   ├── DustAtL2.java        # Main application (JApplet-based GUI)
│   ├── DustAtL2Canvas.java  # Animation canvas and physics engine
│   ├── Body3d.java          # 3D celestial body class
│   └── Data3d.java          # Initial conditions and ephemeris data
├── myutil/
│   ├── AppletFrame.java     # Frame wrapper for running applets standalone
│   ├── GL.java              # Graphics library for 2D drawing
│   ├── SL.java              # String/number parsing utilities
│   └── Format.java          # Number formatting utilities
├── scripts/
│   ├── build.sh             # Build JAR file
│   ├── create-app-bundle.sh # Create macOS .app bundle
│   ├── setup-notarization.sh# Setup Apple credentials
│   └── sign-and-notarize.sh # Sign and notarize for distribution
├── Makefile                 # Build automation
├── README.md
└── .gitignore
```

### Building with Make

```bash
make           # Build JAR file
make app       # Build macOS app bundle
make run       # Build and run
make clean     # Clean build artifacts
make distclean # Clean everything
```

## Scientific Background

### Lagrange Points

The L2 Lagrange point is one of five equilibrium points in the Sun-Earth system where the gravitational forces of the two bodies and the centrifugal force balance. L2 is located about 1.5 million km from Earth, away from the Sun.

### Dust Dynamics

Interplanetary dust particles are affected by:
- Solar gravity
- Planetary gravitational perturbations
- Radiation pressure (Poynting-Robertson effect)
- Solar wind

This simulator focuses on gravitational dynamics to understand how dust accumulates and disperses near Lagrange points.

## History

This simulator was originally written as a Java Applet for web browsers. It has been updated to run as a standalone desktop application.
