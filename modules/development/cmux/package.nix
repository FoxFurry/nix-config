{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  # runtime graphics / GTK4 stack for cmux-app.bin
  gtk4,
  glib,
  harfbuzz,
  fontconfig,
  freetype,
  libGL,
  libglvnd,
  oniguruma,
  pango,
  cairo,
  libepoxy,
  libxkbcommon,
  graphene,
  gdk-pixbuf,
  libgcc,
  # browser engine that agent-browser drives over CDP
  chromium,
}:

# cmux-linux ships prebuilt binaries in a .deb:
#   /usr/bin/cmux            - CLI (socket control, `cmux browser ...`)
#   /usr/bin/cmux-app        - sh wrapper that picks GDK_BACKEND then execs .bin
#   /usr/bin/cmux-app.bin    - the GTK4 GPU terminal (Ghostty statically linked)
#   /usr/lib/cmux/agent-browser  - Rust CDP daemon; launches an external Chrome
#   /usr/lib/cmux/cmuxd-remote   - remote helper
#
# Two NixOS-specific problems this derivation solves:
#   1. ELF interpreter + NEEDED libs point at FHS paths -> autoPatchelfHook.
#   2. cmux-app.bin is a GTK4 GL app. On NixOS the glvnd dispatch layer
#      (libGL.so.1 / libEGL.so.1) comes from the store (libglvnd), while the
#      *vendor* driver (libGLX_nvidia / libEGL_nvidia) lives in
#      /run/opengl-driver/lib. Both must be on the runtime library path, with
#      glvnd resolvable and the driver dir present so glvnd can dispatch to the
#      NVIDIA vendor lib. We wrap with LD_LIBRARY_PATH = libglvnd + driver dir.
#   3. agent-browser resolves a browser via `which google-chrome...`; there is
#      none on NixOS, so we point it at nixpkgs chromium via CHROME_PATH.

stdenv.mkDerivation (finalAttrs: {
  pname = "cmux-linux";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/bradwilson331/cmux-linux/releases/download/${finalAttrs.version}/cmux_${finalAttrs.version}_amd64.deb";
    hash = "sha256-oh0VzluAV31g0EKGy9H6A87s8WSvbXSnoyWJuiPzJy4=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  # Libraries autoPatchelfHook links the binaries against. These mirror the
  # .deb's declared Depends plus what `patchelf --print-needed` reported.
  buildInputs = [
    gtk4
    glib
    harfbuzz
    fontconfig
    freetype
    libGL
    oniguruma
    pango
    cairo
    libepoxy
    libxkbcommon
    graphene
    gdk-pixbuf
    (lib.getLib stdenv.cc.cc) # libstdc++ / libgcc_s
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src ./unpacked
    runHook postUnpack
  '';

  # agent-browser is a self-contained Rust daemon; nothing to autopatch beyond
  # the standard libs. Nothing here dlopens the driver, so the RUNPATH is safe.
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r unpacked/usr/bin $out/bin
    cp -r unpacked/usr/lib $out/lib
    cp -r unpacked/usr/share $out/share

    # Fix the sh wrapper's hardcoded /usr/bin path to the real binary.
    substituteInPlace $out/bin/cmux-app \
      --replace-fail /usr/bin/cmux-app.bin $out/bin/cmux-app.bin

    # The cmux CLI locates agent-browser via current_exe() / $PATH, i.e. it
    # expects it beside the cmux binary. The .deb ships it in lib/cmux (found on
    # Debian because /usr/lib/cmux is added by the app), but our layout differs,
    # so link it into bin/ where cmux looks first. Wrapping (postFixup) then
    # rewrites this symlink target's wrapper in place.
    ln -s $out/lib/cmux/agent-browser $out/bin/agent-browser

    runHook postInstall
  '';

  # After autoPatchelf runs, wrap the two entrypoints:
  #  - system GL driver path for the GTK4 app (NVIDIA proprietary)
  #  - a real browser for the CDP daemon
  postFixup = ''
    # glvnd dispatch (store) + NVIDIA/mesa vendor libs (system driver dir).
    # glvnd must come first so libGL.so.1/libEGL.so.1 resolve to the store copy
    # that knows to load the vendor implementation from /run/opengl-driver/lib.
    glPath="${lib.makeLibraryPath [ libglvnd ]}:/run/opengl-driver/lib"

    # The GTK4 GL terminal: without gl-prefer-gl, NVIDIA's EGL hands the
    # GtkGLArea an OpenGL *ES* context, but Ghostty's renderer needs desktop
    # OpenGL -> "Unable to create a GL context". Forcing desktop GL fixes it.
    # agent-browser resolves its browser via AGENT_BROWSER_EXECUTABLE_PATH (its
    # documented var); CHROME_PATH is kept as a fallback for the `which` list.
    browserEnv=(
      --set-default AGENT_BROWSER_EXECUTABLE_PATH ${lib.getExe chromium}
      --set-default AGENT_BROWSER_ENGINE chrome
      --set-default CHROME_PATH ${lib.getExe chromium}
    )

    # The GTK4 GL terminal: without gl-prefer-gl, NVIDIA's EGL hands the
    # GtkGLArea an OpenGL *ES* context, but Ghostty's renderer needs desktop
    # OpenGL -> "Unable to create a GL context". Forcing desktop GL fixes it.
    wrapProgram $out/bin/cmux-app.bin \
      --prefix LD_LIBRARY_PATH : "$glPath" \
      --set-default GDK_DEBUG gl-prefer-gl \
      "''${browserEnv[@]}"

    wrapProgram $out/bin/cmux \
      --prefix LD_LIBRARY_PATH : "$glPath" \
      "''${browserEnv[@]}"

    # agent-browser is invoked by cmux; give it the same browser + GL context.
    wrapProgram $out/lib/cmux/agent-browser \
      --prefix LD_LIBRARY_PATH : "$glPath" \
      "''${browserEnv[@]}"
  '';

  meta = {
    description = "GPU-accelerated terminal multiplexer for AI coding agents (Linux port of cmux)";
    homepage = "https://github.com/bradwilson331/cmux-linux";
    license = lib.licenses.agpl3Plus;
    mainProgram = "cmux-app";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
