{ lib }:
{
  hasHomeManager = options: lib.hasAttrByPath [ "home-manager" "users" ] options;
}
