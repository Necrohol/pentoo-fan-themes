# Copyright 2026 Pentoo Project / LWIS LLC
# Distributed under the terms of the GNU General Public License v2
# Documentation and metadata: CC BY-SA 4.0

EAPI=8

inherit git-r3
RESTRICT="strip"

DESCRIPTION="Pentoo Plymouth Theme — Future Template Skeleton"
HOMEPAGE="https://github.com/Necrohol/pentoo-future-template"
EGIT_REPO_URI="https://github.com/Necrohol/pentoo-fan-themes.git"
EGIT_BRANCH="main"

LICENSE="GPL-2 Artistic-2 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS=""
IUSE="dracut genkernel ugrd tools"
REQUIRED_USE="?? ( dracut genkernel ugrd )"

RDEPEND="
 sys-boot/plymouth
 dracut? ( || ( sys-kernel/dracut sys-kernel/dracut-ng ) )
 genkernel? ( sys-kernel/genkernel )
 ugrd? ( sys-kernel/ugrd )
 tools? ( dev-python/pillow media-video/ffmpeg )
"

BDEPEND="
 tools? (
  ${PYTHON_DEPS}
  $(python_gen_cond_dep '
   dev-python/pillow[${PYTHON_USEDEP}]
  ')
 )
"

src_install() {
 local theme_dir="/usr/share/plymouth/themes/${PN}"

 # 1️⃣ Install Plymouth theme assets
 insinto "${theme_dir}"
 doins -r "${S}"/plymouth/*

 # 2️⃣ Install Python/Bash/JS tools
 exeinto "${theme_dir}/tools"
 doexe "${S}"/tools/*

 # 3️⃣ Install documentation
 dodoc "${S}"/docs/README.md
 insinto /usr/share/doc/${PF}
 doins "${S}/docs/LICENSE"

 # 4️⃣ Install config examples
 if [[ -d "${S}/conf" ]]; then
  insinto /usr/share/doc/${PF}
  doins "${S}/conf"/*
 fi

 # 5️⃣ Install sources & previews
 insinto "${theme_dir}/sources"
 doins -r "${S}/sources"/*

 # Symlink PNGs for README previews
 keepdir "${theme_dir}/sources/preview"
 shopt -s nullglob
 for f in "${ED}${theme_dir}/sources"/*.png; do
  local fname=$(basename "${f}")
  dosym "../${fname}" "${theme_dir}/sources/preview/${fname}"
 done
 shopt -u nullglob
}

pkg_postinst() {
 elog ""
 elog "================================================"
 elog " Pentoo Plymouth Theme — Future Template"
 elog "================================================"
 elog ""
 elog "Theme installed to /usr/share/plymouth/themes/${PN}"
 elog ""
 elog "--- Recommended: activate theme & rebuild initramfs ---"
 elog " plymouth-set-default-theme -R ${PN}"
 elog ""
 elog "--- Kernel/initramfs integration ---"
 if use dracut; then
  elog "Dracut/dracut-ng: rebuild initramfs automatically on next kernel install."
 fi
 if use genkernel; then
  elog "Genkernel: rebuild initramfs with genkernel --install initramfs"
 fi
 elog ""
 elog "--- Test without rebooting ---"
 elog " plymouthd --debug --attach-to-session"
 elog " plymouth show-splash"
 elog " sleep 5 && plymouth quit"
 elog ""
 if [[ -f /proc/cmdline ]] && ! grep -q "splash" /proc/cmdline; then
  ewarn "WARNING: 'splash' missing from current boot cmdline!"
 fi
}
``` 1

---

## 🧰 What this Template Gives You

This skeleton is already set up as **consistent boilerplate** for any future fan theme you want to create:

✅ **License handling**  
- Code under GPL‑2  
- Theme assets / docs / metadata under CC‑BY‑SA‑4.0  
- Artistic‑2 for other theme art

✅ **Optional initramfs support**  
- `dracut`, `genkernel`, `ugrd` USE flags  
- `REQUIRED_USE` ensures at least one is enabled

✅ **Tools support**  
- Pillow / FFmpeg in RDEPEND and BDEPEND for build tools  
- Installs any Python/Bash/JS scripts under `${theme_dir}/tools`

✅ **Docs & config examples**
- `docs/` installed via `dodoc`
- `conf/` copied under `/usr/share/doc/${PF}`

✅ **Sources & previews**
- Installs all of `sources/` into the theme
- Creates symlinks to PNGs in `sources/preview` for README previews

---

## 🧠 Why This Template Works

This layout matches a **fan‑theme ecosystem** because it:

- Mirrors a real overlay layout (like Gentoo has, e.g. skel ebuilds) 2
- Keeps theme assets and metadata organized
- Makes it trivial to reuse for different themes
- Includes support for optional user tinkering tools

---

## 📦 How To Use This Template

1. **Clone it in your own theme repo**
   - Keep the same directory structure (`docs`, `conf`, `sources`, `plymouth`, `tools`)
   - Update the `DESCRIPTION`, `HOMEPAGE`, and `EGIT_REPO_URI`

2. **Adjust theme assets**
   - Put `.plymouth`, `.script`, and any animation frames in the right folders  
   - PNGs in `sources/preview` are automatically symlinked

3. **Commit and tag**
   - Tag version releases (e.g., `v0.1`)
   - Or use `9999` if building from git

4. **Add optional tools / configs**
   - Pillow/FFmpeg for advanced compositing
   - Example configs in `conf/`

---

## 📌 Quick Template Tips

- Always include a **LICENSE file** in `docs/` so docdoc passes cleanly.  
- Ensure previews are in `sources/preview` for README links to remain valid.  
- Use `${PN}` as the theme directory name to avoid hard‑coding.

---

If you want, I can transform this skeleton even further into:

✨ A **script that auto‑generates a new theme repo** from this skeleton  
✨ An **ebuild generator tool** that takes a theme name and fills this template
