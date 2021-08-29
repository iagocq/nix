# nix
Random things flakes things, like templates, packages and NixOS modules.

## Templates
Flake templates for miscellaneous projects

## Usage

### Listing templates
`nix flake show github:iagocq/nix-templates`

### Using templates
`nix flake new -t github:iagocq/nix-templates .`

`nix flake new -t github:iagocq/nix-templates#generic .`

`nix flake new -t github:iagocq/nix-templates#zig .`
