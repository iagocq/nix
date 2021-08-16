{
  description = "Iago's flake template for miscellaneous projects";
  
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = ({ self, flake-utils, ...}@inputs:
    let
      templates = {
        generic = {
          path = ./templates/generic;
          description = "Generic template";
        };
        rust = {
          path = ./templates/rust;
          description = "Template for Rust projects";
        };
        zig = {
          path = ./templates/zig;
          description = "Template for Zig projects";
        };
      };
    in
    {
      templates = templates;
      defaultTemplate = templates.generic;
    }
  );
}
