# Numerical methods and migration notes

The active implementation is `src/+stanlyfea`. The code in `to_be_compiled`
is retained as the historical `develop` implementation and is not used or packaged.
This refactoring changes numerical behavior deliberately. Historical output must
be compared before treating the new application as a replacement for engineering use.

## Model and units

The solver is a small-displacement, linear elastic, 3-D frame solver with six DOFs
per node: `[Ux Uy Uz Rx Ry Rz]`. Units are supplied by the input file and must be
consistent; rotations are radians, while element roll and support angles are input
in degrees. There is no automatic unit conversion.

Node, element, section and material IDs need not be consecutive or equal.
References are resolved by ID rather than used as array subscripts. The reader
validates IDs, connectivity, property signs, numeric values and block termination
before assembly. Arithmetic is parsed without `eval`, `str2num`, dynamic function
lookup or access to the MATLAB workspace. Numeric fields may use `pi`, `Inf`,
`+ - * / ^`, parentheses and the explicitly allowed functions `sqrt`, `abs`, `sin`,
`cos`, `tan`, `sind`, `cosd`, `tand`, `exp`, `log`, `log10`. Do not put whitespace
inside a numeric field: whitespace separates columns.

## Elements and assembly

The local beam axis is u; v/w are transverse. The original spherical orientation
and roll convention is retained. Section columns are
`ID A Iv Iw Wv Ww shearV shearW [fatigueSizeFactor]`. Bending displacement in v
uses Iw; bending displacement in w uses Iv. Timoshenko shear flexibility uses the
corresponding inertia independently in each plane. Zero shear factors recover
Euler-Bernoulli behavior. The historical torsion approximation `J = Iv + Iw` is
retained: general Saint-Venant torsion and warping are not implemented.

Assembly uses sparse matrices. Uniform axial/torsional loads and linearly varying
transverse loads use consistent nodal loading with three-point Gaussian integration.
Fixed-end forces are subtracted when recovering member end actions. An explicit
mesh-control count r creates r interior nodes; the distributed-load count is also
honored. Zero means no subdivision, replacing the original geometry-dependent
subdivision heuristic. Generated elements record `Mesh.ParentElementIDs`;
original node IDs and element IDs are retained.

Gravity is global acceleration. Material column 5 is mass density per unit volume;
self weight is density times area times acceleration. The original routine omitted
area. Models that compensated for that omission must correct their density values.

Thermal input retains the original convention: mean temperatures of the two
specified bending planes are **additive** for uniform axial expansion. To impose a
uniform change T, use `[T T 0 0]` or `[0 0 T T]`, not `[T T T T]`. Plane gradients
produce thermal moments using the section moduli. Reported strains are mechanical
strains; free thermal expansion is not added to them.

## Constraints and conditioning

Ground constraints use `0` for free, `Inf` for fixed, and a finite positive number
for an elastic ground spring. Inclined supports retain the rotation convention
`Rz(theta)*Ry(phi)`; constraints and springs apply in that support basis. A nonzero
yielded/prescribed displacement overrides that component; zero leaves its ground
constraint unchanged, preserving the input format semantics.

Internal constraints connect two nodes component by component: zero is free,
finite positive is an elastic link, and Inf imposes equal displacement. Axial
spring elements use the entered stiffness directly. General rigid offsets are not
implemented. Redundant equations are removed with rank-revealing QR; incompatible
prescribed values fail explicitly.

The linear system uses Lagrange multipliers after symmetric DOF scaling and
constraint-row normalization. Singular-system warnings, nonfinite solutions,
excessive residuals or scaled condition estimates above 10^15 produce errors.
There is no determinant-based stability test. `Diagnostics` reports force-balance
residual, constraint residual and reciprocal condition estimate.

`Reactions` includes elastic ground support forces and nodal forces transmitted
by rigid ties. At tied nodes these are not all external ground reactions. Member
`EndForces` are physical local nodal actions. `InternalForces` reverses the first
end so both cuts use the same positive-face convention.

## Postprocessing

Stress recovery retains the original section-envelope approximation, combining
axial force and resultant biaxial bending. Compression is kept and combined by
absolute magnitude, correcting cancellation in the old routine. Torsional shear
uses the original polar section-modulus approximation. Transverse shear stress,
detailed section stress maps, plasticity, buckling, geometric nonlinearity and
dynamic analysis are not implemented in the new path.

Nominal and notch-amplified stress and mechanical strain are both calculated.
Static notch columns are `node Kta Ktb Ktt`. Strain shear columns are **tensor**
shear, gamma/2. Zero-demand safety factors remain Inf. Internal-action plots show
beam-end envelopes, not continuous diagrams; subdivide loaded members when
intermediate values matter.

## Fatigue

An `.fstan` supplies alternating loads. A sibling `.stan` supplies mean loads if
present; otherwise mean stress is zero. Refined meshes and base section/material
properties must match; supports and loads may differ. Missing fatigue size and
surface factors default to one. Fatigue notch columns are `node Ktb Ktt q`.

The original empirical Gough-Pollard and Sines/Goodman implementation is retained
as a pure function for traceability. This includes endurance reduction using Kfb,
the 10^3/10^7-cycle Wohler interpolation and the 10^7-cycle cap. Ktt was unused in
the historical formula and is still unused; this is a known limitation, not a
validated torsional fatigue treatment. The old duplicate nominal-fatigue output
was removed. Mean stresses reaching the correction denominator limit return
infinite demand, zero factor and zero estimated cycles. These estimates have not
been independently validated against a fatigue standard.

## Validation status

`tests/testCore.m` includes analytical tests for axial/two-plane bending, torsion,
Timoshenko shear, distributed loading and refinement, gravity, free/restrained
thermal expansion, prescribed displacement, elastic supports and ties, inclined
constraints, compression/notches, file errors and exports. It also reads and solves
all restored historical examples. CI targets R2024b and the latest MATLAB.

`bridge3D_gravity.stan` is an intentional rejection test. Its vertical member 6
connects nodes 11/12, each used by that member alone, with both global Rz rotations
released by the internal ties. Equal Rz at those ends is a zero-energy axial spin.
The input has a genuine unconstrained rotational mode and is rejected rather than
silently stabilized. Its original data are retained. Tests explicitly establish
this mechanism from the model and element stiffness.

The authoring workstation has Runtime v93 (R2017b), but no full MATLAB or Compiler
executable. Active MATLAB sources passed MISS_HIT syntax/lint checks. MATLAB tests,
desktop UI and Compiler builds still require native execution; static checks do
not establish numerical compatibility or successful deployment.
