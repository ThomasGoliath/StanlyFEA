# Deployment verification

## Development machine

1. Install MATLAB R2024b or newer and MATLAB Compiler for Windows x64.
2. Open the repository root without adding `to_be_compiled` to the path.
3. Run `results = runtests('tests'); assertSuccess(results)`.
4. Start `stanly`. Load each example, inspect displacement/reaction tables, stress
   colors and deformation. Test static then fatigue, and switch back. Cancel the
   chooser and try a malformed file: the previous result must remain accessible.
5. Export CSV, MAT, HTML, PNG and PDF; open each. Reopen the MAT file and compare
   values with the GUI. Print HTML to PDF if a full PDF report is required.
6. Repeat startup from another working directory, with spaces/non-ASCII characters
   in filenames. Confirm manuals open and examples are found.
7. Run `build_stanly`; preserve the generated README, installer and build logs.

## Clean Windows machine or VM

1. Use a machine without MATLAB. Do not reuse the old launcher.
2. Run the generated installer. Installing Runtime itself may require elevation,
   depending on the target machine's installation policy.
3. Verify Runtime matches the compiler release at an equal or newer update level.
   An existing older Runtime can coexist; it does not replace the required version.
4. Launch from a shortcut and a working directory outside the installation.
5. Run the same models and exports into a user-writable folder. Compare numeric
   exports with the development run. The installation must not need write access.
6. Confirm close/reopen, malformed-file diagnostics, missing mean-load file,
   incompatible mean mesh, unstable supports and export-failure handling.

Active source does not call Java, create registry associations or launch MATLAB.
The legacy source directory is intentionally excluded from the build. Automated
native solver and desktop smoke tests pass on R2024b and R2026b. The compiled
package has not passed this procedure; the branch is not Runtime-certified.

## Branch provenance

`refactoring-codex` starts at develop commit
`d60302d1c4d933916c1f2a612d6a3ec6ea2470b4`.
Obsolete branch tips recorded before the requested remote deletion:

- `release/7.1.0`: `b9d5cdcff80c4137590745c5a47a54911cbdfe4e`
- `feature/FirstRun`: `a5d004b8e9717915e6f5174bae06ed988cf423cb`

Both obsolete remote branches were deleted on 2026-11-04 after verifying these
exact heads. The [one-time retirement run](https://github.com/ThomasGoliath/StanlyFEA/actions/runs/41808902947)
succeeded; its privileged temporary workflow was then removed from the branch.
`develop` and `master` were left unchanged. A verified pre-refactoring Git bundle
preserves the deleted branch history for recovery.
