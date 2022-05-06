let
  nordix =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqAGsWY6Sg/6u+2lkS9AdsWV4EKh3LkM0rMmnG71TZE";
  unknown1 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2i5DsXy+rffV8n63h5HbRwrUplW6dFPlmj9kG4Sr0S";
  unknown2 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUagdlahSXlKZf9vs+EWVOwo6VqUCXtakJyF1jbwlBZ";
  systems = [ nordix unknown1 unknown2 ];
in { "environment/env.age".publicKeys = systems; }
