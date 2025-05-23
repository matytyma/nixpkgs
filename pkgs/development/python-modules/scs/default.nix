{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  meson-python,
  numpy,
  pkg-config,

  blas,
  lapack,

  # dependencies
  scipy,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scs";
  version = "3.2.7.post2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    tag = version;
    hash = "sha256-A626gK30J4e/TrJMXYc+jMgYw7fNcnWfnTeXlyYQNMM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >= 2.0.0" "numpy"
  '';

  build-system = [
    meson-python
    numpy
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    blas
    lapack
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scs" ];

  meta = {
    description = "Python interface for SCS: Splitting Conic Solver";
    longDescription = ''
      Solves convex cone programs via operator splitting.
      Can solve: linear programs (LPs), second-order cone programs (SOCPs), semidefinite programs (SDPs),
      exponential cone programs (ECPs), and power cone programs (PCPs), or problems with any combination of those cones.
    '';
    homepage = "https://github.com/cvxgrp/scs"; # upstream C package
    downloadPage = "https://github.com/bodono/scs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
