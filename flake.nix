{
  description = "Iago's flake template for miscellaneous projects";
  
  outputs = ({ self, ...}@inputs:
    let
      templates = import ./templates;
      overlay = import ./pkgs;
      nixosModules = import ./modules;
    in
    {
      templates = templates.templates;
      defaultTemplate = templates.default;
      overlay = overlay;
      nixosModules = nixosModules;
    }
  );
}
