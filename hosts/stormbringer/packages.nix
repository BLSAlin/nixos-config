{ pkgs, ... }:
with pkgs; [
  # Gaming related apps
  heroic
  bottles

  # Editors and IDEs
  kdePackages.kate
  jetbrains.idea-ultimate
  jetbrains.rust-rover
  vscode # TODO Check how people integrated vscode

  # Development tools
  postman

  # Misc
  microsoft-edge
]