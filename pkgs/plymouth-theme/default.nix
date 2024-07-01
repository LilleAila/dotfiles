{
  colorScheme,
  stdenv,
  fetchurl,
  writeTextFile,
  imagemagick,
  lib,
}:
let
  logo = ./nix.svg;
  c = colorScheme.palette;
  colors = import ../../lib/colors.nix lib;
in
stdenv.mkDerivation {
  name = "plymouth-theme-${colorScheme.slug}";

  src = writeTextFile {
    name = "theme.script";
    text = ''
      center_x = Window.GetWidth() / 2;
      center_y = Window.GetHeight() / 2;
      baseline_y = Window.GetHeight() * 0.9;


      ### BACKGROUND ###

      Window.SetBackgroundTopColor(%BASE00%);
      Window.SetBackgroundBottomColor(%BASE00%);


      ### LOGO ###

      logo.image = Image("logo.png");
      logo.sprite = Sprite(logo.image);
      logo.sprite.SetPosition(
        center_x - (logo.image.GetWidth() / 2),
        center_y - (logo.image.GetHeight() / 2),
        1
      );

      logo.spinner_active = 1;
      logo.spinner_third = 0;
      logo.spinner_index = 0;
      logo.spinner_max_third = 32;
      logo.spinner_max = logo.spinner_max_third * 3;

      real_index = 0;
      for (third = 0; third < 3; third++) {
        for (index = 0; index < logo.spinner_max_third; index++) {
          subthird = index / logo.spinner_max_third;
          angle = (third + ((Math.Sin(Math.Pi * (subthird - 0.5)) / 2) + 0.5)) / 3;
          logo.spinner_image[real_index] = logo.image.Rotate(2*Math.Pi * angle);
          real_index++;
        }
      }

      fun activate_spinner () {
        logo.spinner_active = 1;
      }

      fun deactivate_spinner () {
        logo.spinner_active = 0;
        logo.sprite.SetImage(logo.image);
      }

      fun refresh_callback () {
        if (logo.spinner_active) {
          logo.spinner_index = (logo.spinner_index + 1) % (logo.spinner_max * 2);
          logo.sprite.SetImage(logo.spinner_image[Math.Int(logo.spinner_index / 2)]);
        }
      }

      Plymouth.SetRefreshFunction(refresh_callback);

      ### PASSWORD ###

      prompt = null;
      bullets = null;
      bullet.image = Image.Text("•", %BASE05%);

      fun password_callback (prompt_text, bullet_count) {
        deactivate_spinner();

        prompt.image = Image.Text("Enter password", %BASE05%);
        prompt.sprite = Sprite(prompt.image);
        prompt.sprite.SetPosition(
          center_x - (prompt.image.GetWidth() / 2),
          baseline_y - prompt.image.GetHeight(),
          1
        );

        total_width = bullet_count * bullet.image.GetWidth();
        start_x = center_x - (total_width / 2);

        bullets = null;
        for (i = 0; i < bullet_count; i++) {
            bullets[i].sprite = Sprite(bullet.image);
            bullets[i].sprite.SetPosition(
              start_x + (i * bullet.image.GetWidth()),
              baseline_y + bullet.image.GetHeight(),
              1
            );
        }
      }

      Plymouth.SetDisplayPasswordFunction(password_callback);


      ### NORMAL ###

      fun normal_callback() {
          prompt = null;
          bullets = null;
          activate_spinner();
      }

      Plymouth.SetDisplayNormalFunction(normal_callback);


      ### QUIT ###

      fun quit_callback() {
        prompt = null;
        bullets = null;
        deactivate_spinner();
      }

      Plymouth.SetQuitFunction(quit_callback);
    '';
  };

  nativeBuildInputs = [ imagemagick ];

  unpackPhase = "true";
  buildPhase =
    let
      base00-rgb = colors.rgb_dec c.base00;
      base05-rgb = colors.rgb_dec c.base05;
    in
    ''
      themeDir="$out/share/plymouth/themes/nix-colors"
      mkdir -p $themeDir

      cp ${logo} template.svg

      sed -i "s/#333333/#${c.base0D}/g" template.svg
      sed -i "s/#555555/#${c.base0C}/g" template.svg

      convert \
        -background transparent \
        -bordercolor transparent \
        -border 42% \
        template.svg \
        $themeDir/logo.png

      cp $src $themeDir/nix-colors.script

      substituteInPlace $themeDir/nix-colors.script \
        --replace-fail "%BASE00%" "${base00-rgb.r}, ${base00-rgb.g}, ${base00-rgb.b}" \
        --replace-fail "%BASE05%" "${base05-rgb.r}, ${base05-rgb.g}, ${base05-rgb.b}"
    '';

  installPhase = ''
    cat << EOF > $themeDir/nix-colors.plymouth
    [Plymouth Theme]
    Name=Nix-colors
    ModuleName=script

    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/nix-colors.script
    EOF
  '';
}
