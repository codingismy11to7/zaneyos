# Gemini Agent Instructions

## Introduction

This document contains instructions and guidelines for the Gemini agent working on the
`zaneyos` project. It is intended to be a living document, updated with new information
and procedures as we work on the project.

## Project Overview

This project is a NixOS configuration managed with Nix Flakes and home-manager. The goal
is to create a highly customized and reproducible desktop environment.

## Development Workflow

0.  **Establish Baseline:** When starting a new task or session, the very first step is
    to check the current git branch and status (`git status && git branch`) to
    understand the current state of the repository.
1.  **Understand the Goal:** Carefully read the user's request to understand the desired
    outcome.
2.  **Locate Relevant Files:** The configuration is highly modular. Key directories
    include `hosts/`, `modules/`, and `profiles/`.
3.  **Make Changes:** Modify the Nix expressions as requested. Adhere to the existing
    code style and conventions.
4.  **Verify Changes:** After making changes, perform a smoke test to ensure the
    configuration is still valid.

## Key Commands

### Smoke Test

To perform a standard smoke test to check for syntax validity in the NixOS
configuration, run the following command from the project root:

```bash
nh os build .
```

### Troubleshooting "does not exist" errors during Smoke Test

If you encounter "does not exist" errors (e.g.,
`error: path '/nix/store/.../modules/home/nix.nix' does not exist`) during the
`nh os build .` smoke test, it typically means that a newly created or modified file has
not been staged in Git.

In such cases, you should use `git add <file_path>` to stage the problematic file.
Remember, you should only perform `git add` for staging new or modified files to resolve
these build errors, and no other Git actions (like committing or pushing) unless
explicitly requested.

### Handling Local External Files in Pure Builds

To reference a local file outside the git repository (e.g., in `/mnt/c/`) while
maintaining a pure Nix build (without `--impure`), use `builtins.fetchurl` with the
file's SHA256 hash.

1.  Calculate the hash: `sha256sum /path/to/file`
2.  Use in Nix:
    ```nix
    builtins.fetchurl {
      url = "file:///path/to/file";
      sha256 = "<calculated_hash>";
    }
    ```