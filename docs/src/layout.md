# Layout of the package

Instead of having all snippets in a single file, the snippets are organized by chapter and grouped in clips by related snippets. E.g. chapter 0 of the R package has snippets 0.1 to 0.5. Those have been combined into 2 clips:

1. `clip-01-03.jl` - contains snippets 0.1 through 0.3
2. `clip-04-05.jl` - contains snippets 0.4 and 0.5.

These 2 files are in scripts/00 and later on processed by Literate.jl to create 3 derived versions, e.g. from `clip_01_03.jl` in scripts/00:

1. `clip-01-03.md` - included in the documentation
2. `clip-01-03.ipynb` - stored in the notebooks/_chapte_r directory
3. `clip-01-03.jl` - stored in the chapters/_chapter_ directory

Occasionally lines in scripts are suppressed when Literate processes input source files, e.g. in Turing scripts the statement
`#nb Turing.turnprogress(false);` is only inserted in the generated notebook but not in the corresponding chapter .jl script.

A clip will contain just a single snippet will be referred to as `03/clip-02.jl`. 

Clips with names such as `02/clip-08t.jl`, `clip_08s.jl` and `clip_08m.jl` contain mcmc implementations using Turing.jl, CmdStan.jl and Mamba.jl respectively. Examples have been added to chapter 2.

The **Turing** versions of the mcmc models are available as e.g. `chapters/08/m8.1t.jl`. Equivalent **CmdStan** versions and, in a few cases **Mamba** models, are provided as well.

Almost identical clips are named e.g. `04/clip-07.0s.jl` and `04/clip-07.1s.jl`. In that specific example just the priors differ.

Scripts using Turing, Mamba or CmdStan need to import those, see the examples in `scripts/02`.

In the `src` directory is a file scriptentry.jl which defines an object `script_dict` which is used to control the generation of documentation, notebooks and .jl scripts in chapters and testing of the notebooks. Output of CmdStan and Mamba scripts is automatically inserted in the documentation. For Turing scripts this needs to be done manually by executing the notebook, exporting the results as .md files (and .svg files if graphics are generated) and copy these to `docs/src/nn`, where nn is the chapter. See `?ScriptEntry` or enter e.g. `script_dict["02"]` in the REPL.
