{ stdenv, fetchFromGitHub }:
{
  minimal = stdenv.mkDerivation {
    pname = "minimal";
    version = "b0f1593b70156ee05c1285e37df015817c82b657";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/where_is_my_sddm_theme/
      echo "
        [General]
        # Password mask character
        passwordCharacter=*
        # Mask password characters or not ("true" or "false")
        passwordMask=true
        # value "1" is all display width, "0.5" is a half of display width etc.
        passwordInputWidth=0.27
        # Background color of password input
        passwordInputBackground=#1a1b26
        # Radius of password input corners
        passwordInputRadius=
        # "true" for visible cursor, "false"
        passwordInputCursorVisible=false
        # Font size of password (in points)
        passwordFontSize=32
        passwordCursorColor=random
        passwordTextColor=#c0caf5

        # Show or not sessions choose label
        showSessionsByDefault=false
        # Font size of sessions choose label (in points).
        sessionsFontSize=12

        # Show or not users choose label
        showUsersByDefault=true
        # Font size of users choose label (in points)
        usersFontSize=20

        # Path to background image
        background=
        # Or use just one color
        backgroundFill=#1a1b26
        backgroundFillMode=aspect

        # Default text color for all labels
        basicTextColor=#c0caf5

        # Radius of background blur
        blurRadius=
      " > $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf
      cp -an $src/where_is_my_sddm_theme/* $out/share/sddm/themes/where_is_my_sddm_theme/
    '';
    src = fetchFromGitHub {
        owner = "stepanzubkov";
        repo = "where-is-my-sddm-theme";
        rev = "40d3bfbc372fe7f5a8539fb5b5505d2383e19f31";
        sha256 = "sha256-9qwZF44KWqMzhHzv6zVp13rO17x9tW6SUeBON18bSqQ=";
    };

  };
}
