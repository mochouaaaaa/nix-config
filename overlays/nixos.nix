{ inputs, pkgs, ... }:

(next: prev: {
  imports = [
    ./pkgs
  ];
})
