{
  description = "Iago's flake template for miscellaneous projects";
  
  outputs = ({ self, ...}@inputs:
    let
      templates = import ./templates;
      pkgs = import ./nur.nix { pkgs = null; };
    in
    {
      templates = templates.templates;
      defaultTemplate = templates.default;
      overlay = pkgs.overlays.all;
      nixosModules = pkgs.modules;
    }
  );
}
