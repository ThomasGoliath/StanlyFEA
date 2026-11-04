# STANLY FEA

MATLAB 3-D frame solver by Tommaso Cavandoli. This branch continues the unfinished
`develop` refactoring toward a standalone application using MATLAB Runtime.

The active code has an explicit model/result API, a programmatic desktop UI, safe
model parsing and a reproducible Compiler entry point. The original `develop`
sources remain in `to_be_compiled` for reference; do not add that directory to the
MATLAB path or use its old launcher. Its name does not mean it is the build input.

## Run in MATLAB

Target baseline: MATLAB R2024b or newer, with no additional toolbox for analysis.
This target is configured for CI; execution on these releases is pending validation.
From the repository root:

```matlab
stanly
```

Choose **Load and solve**, then a model from `examples`. Select mesh, deformation,
loads/supports, stress or beam-end force envelopes. Inspect the result tables and
export CSV, MAT, HTML reports, PNG images or PDF plots. The deformation scale is
explicit and can be changed. Closing or cancelling a file dialog does not discard
the previous successful analysis. A failed load preserves its previous result.

To use the solver without opening the interface:

```matlab
addpath('/absolute/path/to/StanlyFEA')
result = stanly('/absolute/path/to/beam.stan');
result = stanly('/absolute/path/to/beam.stan', 'result.mat');
```

Or use the package directly:

```matlab
addpath('src')
model = stanlyfea.readModel('examples/beam_without.stan');
result = stanlyfea.solveStatic(model);
writetable(stanlyfea.resultTable(result, 'Displacements'), 'displacements.csv');
stanlyfea.writeReport(result, 'report.html');
```

For fatigue use `stanlyfea.analyze` or `stanly`: these load the optional sibling
mean-load `.stan` file. `solveStatic` alone solves only the supplied load case.

Resource paths are independent of the working directory. Input files are not
modified; output is written only to the selected output location. No registry
entries, administrator rights, startup copies, external editor or Java splash
screen are required by the application. Reports use HTML instead of `publish`;
open the report in a browser to print a complete report to PDF.

## Compile for MATLAB Runtime

Compilation requires MATLAB **and MATLAB Compiler** on a Windows machine.
MATLAB Coder is not a substitute. From this directory run:

```matlab
results = runtests('tests');
assertSuccess(results)
build_stanly
```

The build script packages the active source, manuals and examples and generates
`build/application` and `build/installer`. The installer downloads the matching
Runtime. End users do not need a MATLAB license. The Runtime release must match
the release used to compile, with an equal or newer update level. Runtime v93
(R2017b) cannot run an application compiled with R2024b or a newer release.

The old Inno Setup/Matlab-launcher installer on `master` is not used.

See [deployment verification](docs/DEPLOYMENT.md) for the clean-machine procedure
and [numerical methods and changes](docs/NUMERICS.md) before comparing results
with the old program. Native execution and compilation have **not** been verified
on the authoring workstation, which has Runtime but no full MATLAB.

## Tests

```matlab
results = runtests('tests');
assertSuccess(results)
```

GitHub Actions runs the tests on Windows with R2024b and the latest release after
the branch is pushed. Tests include analytical solutions and the historical input
examples recovered from `master`. A green CI result is required before merging;
the GUI and deployed executable also require the manual checks in the deployment
document. No changes are merged to `develop` by the refactoring branch.

## Scope

The new path supports linear static frame analysis, the historical fatigue estimate,
rigid/elastic internal ties, ground and inclined supports, prescribed displacements,
axial springs, linearly distributed loads, refinement, gravity and thermal loads.
The old section-detail visualization and unfinished dynamic analysis remain outside
the new application. The original torsion and stress-envelope approximations and
fatigue-method limitations are documented in `docs/NUMERICS.md`.

The original license is retained in `install_path/license_stan.txt`.
