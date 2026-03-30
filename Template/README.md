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
