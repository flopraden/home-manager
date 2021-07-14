{ cfg, lib }:
with lib;

rec {
  optionsStr = options: concatMapStrings (option: " --${option}") options;
  keybindingStr = sym: undo: bindings: options: (mapAttrsToList (keycomb: action:
          optionalString (action != null) "${optionalString undo "un"}bind${sym}${
            optionalString (options != [] ) (optionsStr options)
          } ${keycomb} ${action}") bindings);
	  
  keybindingsStr = keybindings:
    concatStringsSep "\n" ( flatten (
      mapAttrsToList (part: { bindings, options ? [], sym ? "", undo ? false}:
        ([ "# ${part}" ] ++ (keybindingStr sym undo bindings options)))
         keybindings));

  modeStr = name: keybindings: ''
    mode "${name}" {
    ${keybindingsStr { inherit keybindings; }}
    }
  '';
}
