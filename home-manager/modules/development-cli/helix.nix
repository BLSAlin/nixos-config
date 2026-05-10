{pkgs, ...}: {
	programs.helix = {
		enable = true;
		settings = {
			theme = "ayu_evolve";
		};

		languages.language = [{
			name = "nix";
			auto-format = true;
			formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
		}];
	};
}
