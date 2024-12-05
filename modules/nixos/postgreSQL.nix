{lib, ...}: {
  config.services.postgresql = {
    enable = true;
    ensureDatabases = ["frontdoor"];
    authentication = lib.mkForce ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
}
